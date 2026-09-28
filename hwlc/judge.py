"""The judge pipeline: compile -> synthesis check -> hidden testbench simulation.

Testbench protocol (see docs/ADDING_PROBLEMS.md): the hidden testbench prints
one line per check containing "PASS: <name>" or "FAIL: <name> <details>" and a
final line containing "TB_DONE". Anything else in the output is just log.
"""
import json
import re
import shutil
import signal
import subprocess
import tempfile
import time
import os
from pathlib import Path

from . import tools, vcd
from .problems import LANGUAGES

COMPILE_TIMEOUT = 60
SYNTH_TIMEOUT = 120
MAX_LOG = 20000
MAX_FILE_BLOCKS = 512 * 1024   # ulimit -f (1 KiB blocks): 512 MiB per written file

PASS_RE = re.compile(r"\bPASS:\s*(.*)")
FAIL_RE = re.compile(r"\bFAIL:\s*(.*)")
DONE_RE = re.compile(r"\bTB_DONE\b")
LATCH_RE = re.compile(r"Latch inferred for signal `\\?([^']+)'")


# ---------------------------------------------------------------- helpers

class Run:
    def __init__(self, rc, out, err, timed_out, seconds):
        self.rc, self.out, self.err = rc, out, err
        self.timed_out, self.seconds = timed_out, seconds

    @property
    def ok(self):
        return self.rc == 0 and not self.timed_out

    @property
    def log(self):
        return (self.out + ("\n" if self.out and self.err else "") + self.err).strip()


def run(cmd, cwd, timeout, env=None, max_blocks=None):
    """Run a tool with a wall-clock timeout, killing its whole process group."""
    wrapped = ["sh", "-c", f'ulimit -f {max_blocks or MAX_FILE_BLOCKS}; exec "$@"', "hwlc"] + list(cmd)
    start = time.monotonic()
    try:
        proc = subprocess.Popen(wrapped, cwd=cwd, stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE, text=True, errors="replace",
                                start_new_session=True, env=env)
    except OSError as e:
        return Run(127, "", str(e), False, 0.0)
    try:
        out, err = proc.communicate(timeout=timeout)
        timed_out = False
    except subprocess.TimeoutExpired:
        try:
            os.killpg(proc.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        out, err = proc.communicate()
        timed_out = True
    return Run(proc.returncode, out, err, timed_out, time.monotonic() - start)


class Stage:
    def __init__(self, key, name):
        self.key, self.name = key, name
        self.status = "pending"      # pass | fail | warn | skip | pending
        self.summary = ""
        self.log = []
        self.details = {}
        self.seconds = 0.0

    def add(self, title, r_or_text):
        if isinstance(r_or_text, Run):
            self.seconds += r_or_text.seconds
            text = r_or_text.log
            if r_or_text.timed_out:
                text += "\n[hwlc] command timed out and was killed"
        else:
            text = r_or_text
        self.log.append(f"$ {title}\n{text}".rstrip())

    def finish(self, status, summary):
        self.status, self.summary = status, summary
        return self

    def to_dict(self, workdir):
        log = "\n\n".join(self.log).replace(str(workdir) + "/", "")
        if len(log) > MAX_LOG:
            log = log[:MAX_LOG] + "\n... [log truncated]"
        return {"key": self.key, "name": self.name, "status": self.status,
                "summary": self.summary, "log": log, "details": self.details,
                "seconds": round(self.seconds, 2)}


def _count_warnings(text):
    return len(re.findall(r"(?im)^.*\bwarning\b", text))


# ---------------------------------------------------------------- stages

def _strip_comments(code, fam):
    if fam == "vhdl":
        return re.sub(r"--[^\n]*", "", code)
    code = re.sub(r"/\*.*?\*/", "", code, flags=re.S)
    return re.sub(r"//[^\n]*", "", code)


def _check_rules(p, lang, code, st):
    """Problem-specific source rules, e.g. banning $countones in a bit-trick puzzle."""
    body = _strip_comments(code, LANGUAGES[lang]["family"])
    for rule in p.meta.get("forbidden", []):
        if rule.get("languages") and lang not in rule["languages"]:
            continue
        m = re.search(rule["pattern"], body, flags=re.I if LANGUAGES[lang]["family"] == "vhdl" else 0)
        if m:
            st.add("problem rules", f"forbidden construct '{m.group(0)}': {rule['message']}")
            return st.finish("fail", f"Not allowed in this problem: {rule['message']}")
    return None


def _copy_tb_files(p, lang, wd):
    tb = p.testbench(lang)
    if not tb:
        return None
    other = "tb.vhd" if tb.name == "tb.sv" else "tb.sv"
    for f in tb.parent.iterdir():          # testbench + support files (e.g. vectors.txt)
        if f.is_file() and f.name != other:
            shutil.copy(f, wd / f.name)
    return tb


VERILATOR_FLAGS = ["--timing", "--assert", "-Wno-fatal", "-Wno-lint", "-Wno-style",
                   "--timescale", "1ns/1ps"]


def _uvm_args(p):
    """Extra Verilator arguments (flags + sources, before the user's file) for UVM problems."""
    if not p.meta.get("uvm"):
        return []
    home = tools.uvm_home()
    if not home:
        raise RuntimeError("UVM library not found (third_party/uvm-verilator or HWLC_UVM_HOME)")
    return ["+define+UVM_NO_DPI", f"+incdir+{home}/src", f"{home}/src/uvm_pkg.sv"]


def _prelude(p):
    """Support file compiled before the user's code (types the solution builds on), if any."""
    tb = p.testbench("systemverilog")
    return ["prelude.sv"] if tb and (tb.parent / "prelude.sv").exists() else []


def _cov_flags(p):
    """`cover property` statements only run in Verilator with --coverage-user."""
    return ["--coverage-user"] if p.meta.get("coverage") else []


def _verilator_build_args(p):
    if not p.meta.get("uvm"):
        return ["--trace"] + _cov_flags(p)
    # UVM: ~2000 generated C++ files; -O0 halves the build time and the tests are tiny.
    make = "OPT_FAST=-O0 OPT_SLOW=-O0 OPT_GLOBAL=-O0"
    if tools.find("ccache"):
        make += " OBJCACHE=ccache"
    return ["-MAKEFLAGS", make] + _cov_flags(p)


def _compile_verilator_only(p, src, wd, st):
    """Problems that need Verilator (SVA, constraint randomization): compile with the testbench."""
    verilator = tools.find("verilator")
    if not verilator:
        return st.finish("fail", "This problem needs Verilator (SVA / constraint randomization)")
    tb = _copy_tb_files(p, "systemverilog", wd)
    try:
        uvm = _uvm_args(p)
    except RuntimeError as e:
        st.add("uvm", str(e))
        return st.finish("fail", str(e))
    r = run([verilator, "--lint-only", "-sv"] + VERILATOR_FLAGS + _cov_flags(p) + ["--top-module", "tb"] + uvm +
            _prelude(p) + [src.name, tb.name], wd, COMPILE_TIMEOUT * (10 if uvm else 1))
    st.add(f"verilator --lint-only {src.name} <hidden testbench>", r)
    if not r.ok:
        return st.finish("fail", "Compilation failed")
    st.details["simulator"] = "verilator"
    ignored = [l.strip() for l in r.log.splitlines() if "CONSTRAINTIGN" in l or "Unsupported" in l]
    if ignored:
        st.details["ignored_constraints"] = ignored
        return st.finish("warn", "Verilator IGNORED part of your code (unsupported constraint / construct): "
                                 + ignored[0].split(":", 3)[-1].strip())
    return st.finish("pass", "Compiled with Verilator")


def _compile_verilog(p, lang, src, wd, st):
    if p.meta.get("simulator") == "verilator":
        return _compile_verilator_only(p, src, wd, st)
    iverilog = tools.find("iverilog")
    verilator = tools.find("verilator")
    if not iverilog and not verilator:
        return st.finish("fail", "No Verilog compiler found (install iverilog or verilator)")

    gen = "-g2005" if lang == "verilog" else "-g2012"
    if iverilog:
        r = run([iverilog, gen, "-Wall", "-Wno-timescale", "-s", p.top,
                 "-o", "compile_check.vvp", src.name], wd, COMPILE_TIMEOUT)
        st.add(f"iverilog {gen} -s {p.top} {src.name}", r)
        if not r.ok:
            # Icarus implements only part of SystemVerilog: let Verilator have a go
            if lang == "systemverilog" and verilator:
                r2 = run([verilator, "--lint-only", "-Wno-fatal", "-Wno-lint", "-Wno-style",
                          "--timing", "-sv", "--top-module", p.top, src.name], wd, COMPILE_TIMEOUT)
                st.add(f"verilator --lint-only -sv --top-module {p.top} {src.name}", r2)
                if r2.ok:
                    st.details["simulator"] = "verilator"
                    return st.finish("warn", "Icarus Verilog does not support this SystemVerilog; "
                                             "compiled and simulated with Verilator instead")
            return st.finish("fail", "Compilation failed")

    warnings = 0
    # Verilator's linter is much stricter; for digital problems its findings
    # are shown as warnings (it is fatal only when it is the only compiler).
    if verilator and (p.synthesis == "required" or not iverilog):
        std = ["--default-language", "1364-2005"] if lang == "verilog" else ["-sv"]
        r = run([verilator, "--lint-only", "-Wall", "-Wno-DECLFILENAME",
                 "-Wno-UNUSEDSIGNAL", "-Wno-UNUSEDPARAM", "--timing",
                 "--top-module", p.top] + std + [src.name], wd, COMPILE_TIMEOUT)
        st.add(f"verilator --lint-only -Wall --top-module {p.top} {src.name}", r)
        if not r.ok and not iverilog:
            return st.finish("fail", "Compilation failed")
        warnings = _count_warnings(r.log)

    if warnings:
        return st.finish("warn", f"Compiled with {warnings} lint warning(s)")
    return st.finish("pass", "Compiled successfully")


def _compile_vhdl(p, src, wd, st):
    ghdl = tools.find("ghdl")
    if not ghdl:
        return st.finish("fail", "GHDL not found (install ghdl to use VHDL)")
    (wd / "work").mkdir(exist_ok=True)
    r = run([ghdl, "-a", "--std=08", "--workdir=work", src.name], wd, COMPILE_TIMEOUT)
    st.add(f"ghdl -a --std=08 {src.name}", r)
    if not r.ok:
        return st.finish("fail", "Analysis failed")
    r = run([ghdl, "-e", "--std=08", "--workdir=work", p.top.lower()], wd, COMPILE_TIMEOUT)
    st.add(f"ghdl -e --std=08 {p.top.lower()}", r)
    if not r.ok:
        return st.finish("fail", f"Elaboration of '{p.top}' failed")
    if _count_warnings(r.log):
        return st.finish("warn", "Compiled with warnings")
    return st.finish("pass", "Analyzed and elaborated successfully")


YOSYS_SCRIPT = """\
read_verilog {read_flags} {file}
{chparam}
hierarchy -check -top {top}
proc
flatten
opt_clean
synth -top {top}
check -assert
tee -o stat.txt stat
write_json netlist.json
"""


def _chparam(p, top, fam):
    """Yosys command applying the parameter values the testbench uses (problem.json synth_params)."""
    params = p.meta.get("synth_params", {})
    if not params or fam == "vhdl":            # VHDL generics are applied by ghdl --synth -g
        return ""
    return "chparam " + " ".join(f"-set {k} {v}" for k, v in params.items()) + f" {top}"


def _synthesize(p, lang, src, wd, st):
    fam = LANGUAGES[lang]["family"]
    top = p.top.lower() if fam == "vhdl" else p.top
    yosys = tools.find("yosys")
    chparam = _chparam(p, top, fam)

    netlist_src = src.name
    read_flags = "-sv" if lang == "systemverilog" else ""
    if fam == "vhdl":
        ghdl = tools.find("ghdl")
        gens = [f"-g{k}={v}" for k, v in p.meta.get("synth_params", {}).items()]
        r = run([ghdl, "--synth", "--std=08", "--workdir=work", "--out=verilog"] + gens + [top],
                wd, SYNTH_TIMEOUT)
        st.add(f"ghdl --synth --std=08 --out=verilog {top}", Run(r.rc, "", r.err, r.timed_out, r.seconds))
        if not r.ok:
            latches = re.findall(r'latch infered for net "([^"]+)"', r.err)
            if latches:
                st.details["latches"] = latches
                return st.finish("fail", f"Unintended latch inferred ({', '.join(latches)})")
            return st.finish("fail", "Not synthesizable (GHDL synthesis failed)")
        (wd / "ghdl_synth.v").write_text(r.out)
        netlist_src = "ghdl_synth.v"
        read_flags = ""
        if not yosys:
            return st.finish("warn", "GHDL synthesis passed (yosys missing: no netlist stats)")

    if not yosys:
        return st.finish("skip", "yosys not installed - synthesis not checked")

    script = YOSYS_SCRIPT.format(read_flags=read_flags, file=netlist_src, top=top, chparam=chparam)
    (wd / "synth.ys").write_text(script)
    r = run([yosys, "-q", "-l", "yosys.log", "-s", "synth.ys"], wd, SYNTH_TIMEOUT)
    full = (wd / "yosys.log").read_text(errors="replace") if (wd / "yosys.log").exists() else ""
    interesting = [l for l in full.splitlines()
                   if re.search(r"(?i)error|warning|latch inferred", l)
                   and "No latch inferred" not in l and "network is combinational" not in l]
    st.add(f"yosys synth -top {top}", Run(r.rc, "\n".join(interesting), r.err if not r.ok else "",
                                          r.timed_out, r.seconds))
    stat = (wd / "stat.txt").read_text(errors="replace") if (wd / "stat.txt").exists() else ""
    if stat:
        st.add("yosys stat", stat.strip())

    latches = sorted(set(LATCH_RE.findall(full)))
    if latches:
        st.details["latches"] = [l.replace("\\", "").split(".")[-1] for l in latches]

    if not r.ok and latches:
        return st.finish("fail", f"Unintended latch inferred ({', '.join(st.details['latches'])})")
    if not r.ok:
        msg = "Not synthesizable"
        err = next((l for l in (r.err + "\n" + full).splitlines() if "ERROR" in l), "")
        if "check pass" in err or "Found and reported" in err:
            msg = "Synthesis design check failed (multiple drivers / logic loop / undriven)"
        elif "syntax error" in err and fam != "vhdl":
            msg = ("Yosys could not parse this code (it supports a subset of SystemVerilog); "
                   "rewrite the flagged construct in plainer SV")
        return st.finish("fail", msg)

    net = json.loads((wd / "netlist.json").read_text())
    mod = net.get("modules", {}).get(top) or next(iter(net.get("modules", {}).values()), {})
    cells = {}
    for c in mod.get("cells", {}).values():
        cells[c["type"]] = cells.get(c["type"], 0) + 1
    ffs = sum(n for t, n in cells.items() if "FF" in t.upper())
    n_latch = sum(n for t, n in cells.items() if "LATCH" in t.upper())
    st.details["stats"] = {"cells": sum(cells.values()), "flip_flops": ffs,
                           "latches": n_latch, "by_type": cells}

    ports = {name.lower(): {"dir": info["direction"], "width": len(info["bits"])}
             for name, info in mod.get("ports", {}).items()}
    problems = _interface_diff(p.ports, ports)
    if problems:
        st.details["interface"] = problems
        return st.finish("fail", "Interface mismatch: " + "; ".join(problems))

    undriven = _undriven_outputs(mod)
    if undriven:
        st.details["undriven"] = undriven
        return st.finish("fail", "Output(s) not driven: " + ", ".join(undriven))

    max_ff = p.meta.get("max_flip_flops")
    if max_ff is not None and ffs + n_latch > max_ff:
        return st.finish("fail", "Must be purely combinational" if max_ff == 0 else
                         f"Uses {ffs + n_latch} storage elements, limit is {max_ff}")

    if n_latch and not p.meta.get("allow_latches", False):
        names = ", ".join(st.details.get("latches", [])) or f"{n_latch} latch cell(s)"
        return st.finish("fail", f"Unintended latch inferred ({names})")

    timing = _timing(p, top, netlist_src, read_flags, wd, st, chparam)
    summary = f"Synthesized: {sum(cells.values())} cells, {ffs} flip-flops"
    if timing:
        summary += f", logic depth {timing['depth']}"
        limit = p.meta.get("max_logic_depth")
        if limit is not None and timing["depth"] > limit:
            st.details["timing_fail"] = True
            return st.finish("fail", f"Timing not met: logic depth {timing['depth']} > {limit} "
                                     f"(critical path {timing['start']} -> {timing['end']})")
    return st.finish("pass", summary)


LTP_SCRIPT = """\
read_verilog {read_flags} {file}
{chparam}
synth -top {top} -flatten -noabc
opt_clean
ltp -noff
"""
LTP_LEN_RE = re.compile(r"Longest topological path in \S+ \(length=(\d+)\):")
LTP_NODE_RE = re.compile(r"^\s*\d+:\s+(\S+)(?: \[(\d+)\])?")


def _timing(p, top, file, read_flags, wd, st, chparam=""):
    """Longest combinational path, counted in generic gates (before ABC re-optimizes it).

    Paths start at inputs or flip-flop outputs and end at outputs or flip-flop inputs,
    so the number approximates the logic levels a clock period has to cover.
    """
    yosys = tools.find("yosys")
    (wd / "ltp.ys").write_text(LTP_SCRIPT.format(read_flags=read_flags, file=file, top=top,
                                                  chparam=chparam))
    r = run([yosys, "-s", "ltp.ys"], wd, SYNTH_TIMEOUT)
    m = LTP_LEN_RE.search(r.out)
    if not r.ok or not m:
        return None
    lines = r.out[m.end():].splitlines()[1:]
    nodes = []
    for line in lines:
        nm = LTP_NODE_RE.match(line)
        if not nm:
            break
        name = nm.group(1)
        if name.startswith("\\"):
            name = name[1:] + (f"[{nm.group(2)}]" if nm.group(2) else "")
        else:
            name = None                      # tool-generated net
        nodes.append(name)
    named = [n for n in nodes if n]
    timing = {"depth": int(m.group(1)),
              "start": nodes[0] or "?" if nodes else "?",
              "end": nodes[-1] or "?" if nodes else "?",
              "through": [n for n in named[1:-1]][:12],
              "limit": p.meta.get("max_logic_depth")}
    st.details["timing"] = timing
    path = " -> ".join([timing["start"]] + timing["through"] + [timing["end"]])
    st.add("critical path (generic gates, before ABC)",
           f"logic depth {timing['depth']}: {path}")
    return timing


def _undriven_outputs(mod):
    """Names of output ports with bits that nothing in the netlist drives."""
    driven = set()
    for info in mod.get("ports", {}).values():
        if info["direction"] == "input":
            driven.update(b for b in info["bits"] if isinstance(b, int))
    for cell in mod.get("cells", {}).values():
        dirs = cell.get("port_directions", {})
        for pin, bits in cell.get("connections", {}).items():
            if dirs.get(pin) == "output":
                driven.update(b for b in bits if isinstance(b, int))
    bad = []
    for name, info in mod.get("ports", {}).items():
        if info["direction"] != "output":
            continue
        if any(b in ("x", "z") or (isinstance(b, int) and b not in driven) for b in info["bits"]):
            bad.append(name)
    return bad


def _interface_diff(expected, actual):
    problems = []
    for port in expected:
        name = port["name"].lower()
        got = actual.get(name)
        if not got:
            problems.append(f"missing port '{port['name']}'")
            continue
        if got["dir"] != port["dir"]:
            problems.append(f"port '{port['name']}' should be {port['dir']}, is {got['dir']}")
        if got["width"] != port.get("width", 1):
            problems.append(f"port '{port['name']}' should be {port.get('width', 1)} bit(s), "
                            f"is {got['width']}")
    extra = set(actual) - {p["name"].lower() for p in expected}
    for name in sorted(extra):
        problems.append(f"unexpected port '{name}'")
    return problems


def _simulate(p, lang, src, wd, st, sim=None):
    tb = _copy_tb_files(p, lang, wd)
    if not tb:
        return st.finish("fail", "This problem has no testbench for this language"), None
    fam = LANGUAGES[lang]["family"]

    if fam == "verilog":
        sim = sim or tools.sv_simulator()
        if sim == "iverilog":
            # testbench first: a design without `timescale then inherits its 1ns/1ps
            r = run([tools.find("iverilog"), "-g2012", "-Wno-timescale", "-s", "tb", "-o", "sim.vvp",
                     tb.name, src.name], wd, COMPILE_TIMEOUT)
            st.add(f"iverilog -g2012 -s tb {src.name} <hidden testbench>", r)
            if not r.ok:
                return st.finish("fail", "Design does not compile against the testbench "
                                         "(check module name and ports)"), None
            r = run([tools.find("vvp"), "-n", "sim.vvp", "+vcd"], wd, p.timeout)
        elif sim == "verilator":
            uvm = _uvm_args(p)
            r = run([tools.find("verilator"), "--binary", "-j", "0", "--top-module", "tb",
                     "-o", "sim"] + VERILATOR_FLAGS + _verilator_build_args(p) + uvm +
                    _prelude(p) + [src.name, tb.name], wd, 900 if uvm else max(COMPILE_TIMEOUT, 180),
                    max_blocks=4 * 1024 * 1024 if uvm else None)   # UVM precompiled headers are large
            st.add(f"verilator --binary --top-module tb {src.name} <hidden testbench>", r)
            if not r.ok:
                return st.finish("fail", "Design does not compile against the testbench "
                                         "(check module name and ports)"), None
            r = run(["./obj_dir/sim", "+vcd"], wd, p.timeout)
        else:
            return st.finish("fail", "No Verilog simulator found (install iverilog)"), None
    else:
        ghdl = tools.find("ghdl")
        r = run([ghdl, "-a", "--std=08", "--workdir=work", tb.name], wd, COMPILE_TIMEOUT)
        st.add("ghdl -a --std=08 <hidden testbench>", r)
        if not r.ok:
            return st.finish("fail", "Design does not compile against the testbench "
                                     "(check entity name and ports)"), None
        r = run([ghdl, "--elab-run", "--std=08", "--workdir=work", "tb",
                 "--vcd=wave.vcd", "--ieee-asserts=disable-at-0"], wd, p.timeout)

    st.add("run simulation", r)
    return _grade(r, st), r


def _grade(r, st):
    out = r.out + "\n" + r.err
    tests = []
    for line in out.splitlines():
        m = PASS_RE.search(line)
        if m:
            tests.append({"name": m.group(1).strip(), "pass": True, "detail": ""})
            continue
        m = FAIL_RE.search(line)
        if m:
            name, _, detail = m.group(1).strip().partition(" -- ")
            tests.append({"name": name, "pass": False, "detail": detail})
    done = bool(DONE_RE.search(out))
    passed = sum(t["pass"] for t in tests)
    st.details["tests"] = tests[:200]
    st.details["passed"] = passed
    st.details["total"] = len(tests)
    st.details["done"] = done
    if r.timed_out:
        st.details["verdict"] = "Time Limit Exceeded"
        return st.finish("fail", "Simulation timed out (does your design hang the testbench?)")
    if not done:
        st.details["verdict"] = "Runtime Error"
        return st.finish("fail", "Simulation ended before the testbench finished "
                                 f"(exit code {r.rc})")
    if not tests:
        st.details["verdict"] = "Internal Error"
        return st.finish("fail", "Testbench reported no results")
    if passed < len(tests):
        st.details["verdict"] = "Wrong Answer"
        return st.finish("fail", f"{passed}/{len(tests)} checks passed")
    st.details["verdict"] = "Accepted"
    return st.finish("pass", f"All {len(tests)} checks passed")


def _port_rank(problem, name):
    """Sort key putting ports first (in declaration order), then internal signals."""
    inst, _, base = name.rpartition(".")
    base = base.split("[")[0].lower()
    order = [p["name"].lower() for p in problem.ports]
    rank = order.index(base) if base in order else len(order)
    return (inst, rank, base)


# ---------------------------------------------------------------- entry point

def _only_examples(problem, st):
    """Restrict graded checks to the problem's visible example cases ("run" mode)."""
    tests = st.details.get("tests", [])
    cases = []
    for i, ex in enumerate(problem.examples):
        t = next((t for t in tests if t["name"].startswith(ex["check"])), None)
        cases.append(dict(t or {"name": ex["check"], "pass": False,
                                "detail": "check did not run"}, case=i))
    st.details["tests"] = cases
    st.details["passed"] = sum(c["pass"] for c in cases)
    st.details["total"] = len(cases)
    if st.details.get("verdict") in ("Accepted", "Wrong Answer"):
        ok = all(c["pass"] for c in cases)
        st.details["verdict"] = "Accepted" if ok else "Wrong Answer"
        st.status = "pass" if ok else "fail"
        st.summary = f"{st.details['passed']}/{len(cases)} example cases passed"


ERROR_LINE_RE = re.compile(r"^\s*(ERROR|%Error|FATAL|%Fatal)\b", re.M)
DUMP_MODULE = """module hwlc_dump;
    initial if ($test$plusargs("vcd")) begin
        $dumpfile("wave.vcd");
        $dumpvars(2, tb);
    end
endmodule
"""


def _judge_testbench(problem, lang, code, src, wd, stages, mode):
    """Grade a user-written testbench by mutation testing.

    The testbench must run cleanly on the correct design (no false alarms) and report an
    error - a line starting with ERROR / FATAL, e.g. from $error or $fatal - on each of the
    hidden buggy variants.
    """
    compile_st, synth_st, sim_st = stages
    iverilog, vvp = tools.find("iverilog"), tools.find("vvp")
    if not (iverilog and vvp):
        compile_st.finish("fail", "Testbench problems need Icarus Verilog (iverilog)")
        return "Compile Error"
    dv = problem.path / "dv"
    shutil.copy(dv / "golden.v", wd / "golden.v")
    (wd / "hwlc_dump.v").write_text(DUMP_MODULE)
    mutants = json.loads((dv / "mutants.json").read_text())

    def build(dut_file, out):
        return run([iverilog, "-g2012", "-Wno-timescale", "-s", "tb", "-s", "hwlc_dump", "-o", out,
                    src.name, dut_file, "hwlc_dump.v"], wd, COMPILE_TIMEOUT)

    r = build("golden.v", "golden.vvp")
    compile_st.add(f"iverilog -g2012 -s tb {src.name} <hidden design>", r)
    if not r.ok:
        compile_st.finish("fail", "Your testbench does not compile against the design "
                                  f"(top module must be 'tb', instantiate '{problem.top}')")
        return "Compile Error"
    compile_st.finish("pass", "Testbench compiled against the design")
    synth_st.finish("skip", "Testbench problem - nothing to synthesize")

    tests = []
    r = run([vvp, "-n", "golden.vvp", "+vcd"], wd, problem.timeout)
    sim_st.add("run your testbench on the correct design", r)
    golden_errors = ERROR_LINE_RE.findall(r.out + "\n" + r.err)
    if r.timed_out:
        sim_st.details["verdict"] = "Time Limit Exceeded"
        tests.append({"name": "correct design: runs to completion", "pass": False,
                      "detail": "your testbench did not finish (add $finish and a watchdog)"})
    else:
        clean = not golden_errors and r.rc == 0
        tests.append({"name": "correct design: no false alarms", "pass": clean,
                      "detail": "" if clean else "your testbench reported an error on the correct design"})

    for i, m in enumerate(mutants, 1):
        shutil.copy(dv / "mutants" / m["file"], wd / m["file"])
        rb = build(m["file"], "mutant.vvp")
        if not rb.ok:
            sim_st.add(f"bug {i}: compile", rb)
            tests.append({"name": f"bug {i} - {m['hint']}", "pass": False,
                          "detail": "testbench does not compile against this variant"})
            continue
        rm = run([vvp, "-n", "mutant.vvp"], wd, problem.timeout)
        killed = bool(ERROR_LINE_RE.search(rm.out + "\n" + rm.err)) or (rm.rc != 0 and not rm.timed_out)
        sim_st.add(f"bug {i} ({m['hint']}): {'detected' if killed else 'NOT detected'}",
                   "\n".join((rm.out + rm.err).splitlines()[-8:]))
        tests.append({"name": f"bug {i} - {m['hint']}" + (f": {m['desc']}" if killed else ""),
                      "pass": killed,
                      "detail": "" if killed else "your testbench did not report an error for this buggy design"})

    caught = sum(t["pass"] for t in tests[1:])
    sim_st.details.update({"tests": tests, "passed": sum(t["pass"] for t in tests),
                           "total": len(tests), "done": True, "bugs_caught": caught,
                           "bugs_total": len(mutants)})
    if "verdict" not in sim_st.details:
        sim_st.details["verdict"] = "Accepted" if all(t["pass"] for t in tests) else "Wrong Answer"
    ok = sim_st.details["verdict"] == "Accepted"
    sim_st.finish("pass" if ok else "fail",
                  f"Caught {caught}/{len(mutants)} bugs" + ("" if tests[0]["pass"] else ", false alarm on the correct design"))
    if mode == "run" and problem.examples:
        _only_examples(problem, sim_st)
    return sim_st.details["verdict"]


def _judge_checker(problem, lang, code, src, wd, stages, mode):
    """Grade a checker / assertion module by replaying hidden traces.

    The hidden testbench drives trace N when run with +trace=N and prints TRACE_DONE at the end.
    Traces marked "violation" must make the checker report an error (a failing assertion,
    $error, or a line starting with ERROR); clean traces must not.
    """
    compile_st, synth_st, sim_st = stages
    _compile_verilator_only(problem, src, wd, compile_st)
    if compile_st.status == "fail":
        return "Compile Error"
    synth_st.finish("skip", "Checker - nothing to synthesize")
    r = run([tools.find("verilator"), "--binary", "-j", "0", "--top-module", "tb", "--trace",
             "-o", "sim"] + VERILATOR_FLAGS + [src.name, "tb.sv"], wd, max(COMPILE_TIMEOUT, 180))
    sim_st.add("verilator --binary <hidden testbench> + your checker", r)
    if not r.ok:
        sim_st.finish("fail", "Checker does not compile against the testbench")
        return "Compile Error"
    traces = problem.meta.get("traces")
    if traces is None:
        traces = json.loads((problem.path / "tb" / "traces.json").read_text())
    tests = []
    for i, tr in enumerate(traces):
        args = ["./obj_dir/sim", f"+trace={i}", "+verilator+error+limit+1000"]
        if i == 0:
            args.append("+vcd")
        rr = run(args, wd, problem.timeout)
        out = rr.out + "\n" + rr.err
        fired = bool(ERROR_LINE_RE.search(out)) or "Assertion failed" in out
        finished = "TRACE_DONE" in out or fired
        ok = finished and fired == tr["violation"]
        if rr.timed_out:
            detail = "simulation timed out"
        elif tr["violation"] and not fired:
            detail = "your checker did not flag this violation"
        elif not tr["violation"] and fired:
            detail = "false alarm: your checker fired on a legal trace"
        else:
            detail = ""
        sim_st.add(f"trace {i}: {tr['name']} -> {'fired' if fired else 'silent'}",
                   "\n".join(out.strip().splitlines()[-6:]))
        tests.append({"name": tr["name"], "pass": ok, "detail": detail})
    passed = sum(t["pass"] for t in tests)
    sim_st.details.update({"tests": tests, "passed": passed, "total": len(tests), "done": True,
                           "verdict": "Accepted" if passed == len(tests) else "Wrong Answer"})
    sim_st.finish("pass" if passed == len(tests) else "fail", f"{passed}/{len(tests)} traces judged correctly")
    if mode == "run" and problem.examples:
        _only_examples(problem, sim_st)
    return sim_st.details["verdict"]


def judge(problem, lang, code, mode="submit", keep=False):
    """Judge `code` for `problem`.

    mode: "check"  - compile + synthesis only
          "run"    - everything, but only the visible example cases are graded
          "submit" - everything, all hidden checks are graded
    """
    if lang not in problem.languages:
        raise ValueError(f"{problem.slug} does not support {lang}")
    started = time.monotonic()
    wd = Path(tempfile.mkdtemp(prefix="hwlc-"))
    src = wd / ("design" + LANGUAGES[lang]["ext"])
    src.write_text(code)
    fam = LANGUAGES[lang]["family"]

    compile_st = Stage("compile", "Compile")
    synth_st = Stage("synth", "Synthesis")
    sim_st = Stage("sim", "Testbench")
    stages = [compile_st, synth_st, sim_st]
    verdict = None
    wave = None

    try:
        kind = problem.meta.get("kind")
        if kind in ("testbench", "checker"):
            if _check_rules(problem, lang, code, compile_st):
                verdict = "Rule Violation"
            elif kind == "checker":
                verdict = _judge_checker(problem, lang, code, src, wd, stages, mode)
            else:
                verdict = _judge_testbench(problem, lang, code, src, wd, stages, mode)
            wave = vcd.parse(wd / "wave.vcd") if (wd / "wave.vcd").exists() else None
            if wave:
                wave["signals"].sort(key=lambda s: _port_rank(problem, s["name"]))
        elif _check_rules(problem, lang, code, compile_st):
            pass
        elif fam == "verilog":
            _compile_verilog(problem, lang, src, wd, compile_st)
        else:
            _compile_vhdl(problem, src, wd, compile_st)

        if problem.meta.get("kind") in ("testbench", "checker"):
            pass
        elif compile_st.status == "fail":
            verdict = ("Rule Violation" if compile_st.summary.startswith("Not allowed")
                       else "Compile Error")
        else:
            if problem.synthesis == "none":
                synth_st.finish("skip", "Behavioral model - synthesis not required")
            else:
                _synthesize(problem, lang, src, wd, synth_st)
                if synth_st.status == "fail" and problem.synthesis == "optional":
                    synth_st.status = "info"
                    synth_st.summary = ("Not synthesizable - expected for a behavioral "
                                        "model (not graded)")
                elif synth_st.status == "pass" and problem.synthesis == "optional":
                    synth_st.summary += " (not graded)"
            if synth_st.status == "fail" and not synth_st.details.get("timing_fail"):
                verdict = "Synthesis Error"

        if problem.meta.get("kind") in ("testbench", "checker"):
            pass
        elif verdict is None and mode == "check":
            sim_st.finish("skip", "Not run (use Submit to run the testbench)")
            verdict = "Timing Violation" if synth_st.details.get("timing_fail") else "Checks Passed"
        elif verdict is None:
            _, r = _simulate(problem, lang, src, wd, sim_st, compile_st.details.get("simulator"))
            if mode == "run" and problem.examples and "tests" in sim_st.details:
                _only_examples(problem, sim_st)
            verdict = sim_st.details.get("verdict") or "Compile Error"
            if verdict == "Accepted" and synth_st.details.get("timing_fail"):
                verdict = "Timing Violation"
            if (wd / "wave.vcd").exists():
                wave = vcd.parse(wd / "wave.vcd")
                if wave:
                    wave["signals"].sort(key=lambda s: _port_rank(problem, s["name"]))

        for s in stages:
            if s.status == "pending":
                s.finish("skip", "Not run")

        result = {
            "problem": problem.slug, "language": lang, "mode": mode,
            "verdict": verdict,
            "accepted": verdict == "Accepted",
            "passed": sim_st.details.get("passed", 0),
            "total": sim_st.details.get("total", 0),
            "stages": [s.to_dict(wd) for s in stages],
            "wave": wave,
            "seconds": round(time.monotonic() - started, 2),
        }
        if keep:
            result["workdir"] = str(wd)
        return result
    finally:
        if not keep:
            shutil.rmtree(wd, ignore_errors=True)
