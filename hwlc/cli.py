"""Command-line interface: python -m hwlc <command>."""
import argparse
import json
import sys
from pathlib import Path

from . import judge, problems, tools, store

COLORS = {"pass": "\033[32m", "fail": "\033[31m", "warn": "\033[33m",
          "info": "\033[36m", "skip": "\033[90m", "end": "\033[0m"}
ICONS = {"pass": "✔", "fail": "✘", "warn": "!", "info": "i", "skip": "-"}


def _c(status, text):
    if not sys.stdout.isatty():
        return text
    return COLORS.get(status, "") + text + COLORS["end"]


def _lang_from_file(path):
    ext = Path(path).suffix.lower()
    for lang, info in problems.LANGUAGES.items():
        if info["ext"] == ext or (ext == ".vhdl" and lang == "vhdl"):
            return lang
    raise SystemExit(f"cannot infer language from '{path}', pass --lang")


def print_result(res, verbose=False):
    for st in res["stages"]:
        print(_c(st["status"], f"  {ICONS.get(st['status'], '?')} {st['name']:<10}")
              + f" {st['summary']}")
        if verbose or (st["status"] == "fail" and not st["details"].get("tests")):
            if st["log"]:
                print("\n".join("      " + l for l in st["log"].splitlines()))
        for t in st["details"].get("tests", []):
            if not t["pass"] or verbose:
                mark = _c("pass", "PASS") if t["pass"] else _c("fail", "FAIL")
                detail = f" -- {t['detail']}" if t.get("detail") else ""
                print(f"      {mark} {t['name']}{detail}")
    status = "pass" if res["accepted"] or res["verdict"] == "Checks Passed" else "fail"
    print(_c(status, f"\n  {res['verdict']}") + f"  ({res['seconds']}s)")


def cmd_list(args):
    solved = store.solved()
    for p in problems.load_all():
        mark = "✔" if p.slug in solved else " "
        print(f" {mark} {p.id:>3}. {p.title:<36} {p.difficulty:<7} {p.category:<9} "
              f"[{p.slug}]  {', '.join(p.languages)}")


def cmd_show(args):
    p = _problem(args.problem)
    print(f"# {p.id}. {p.title}  ({p.difficulty}, synthesis: {p.synthesis})\n")
    print(p.description())
    from . import waves
    ws = p.waves()
    if ws:
        print("\n### Example waveforms\n")
        for w in ws:
            print(waves.ascii(w) + "\n")
    if args.starter:
        print(f"\n--- starter ({args.starter}) ---\n{p.starter(args.starter)}")


def cmd_submit(args):
    p = _problem(args.problem)
    lang = args.lang or _lang_from_file(args.file)
    code = Path(args.file).read_text()
    res = judge.judge(p, lang, code, mode="check" if args.check else "submit", keep=args.keep)
    if args.json:
        res.pop("wave", None)
        print(json.dumps(res, indent=2))
    else:
        print(f"{p.title} [{lang}]")
        print_result(res, args.verbose)
        if args.keep:
            print(f"  work directory kept at {res['workdir']}")
    if not args.check:
        store.record(res, code)
    return 0 if res["accepted"] or res["verdict"] == "Checks Passed" else 1


def cmd_selftest(args):
    """Judge every reference solution; all of them must be accepted."""
    failures = 0
    for p in problems.load_all():
        if args.problem and p.slug not in args.problem:
            continue
        for lang in p.languages:
            f = p.solution_file(lang)
            if not f and lang == "systemverilog" and p.solution_file("verilog"):
                f = p.solution_file("verilog")      # Verilog-2005 is valid SystemVerilog
            if not f and lang == "vhdl" and p.testbench("vhdl"):
                ok = _smoke_vhdl_tb(p)
                failures += not ok
                print(_c("pass" if ok else "fail",
                         f"  {'~' if ok else '✘'} {p.slug:<28} {lang:<14} "
                         f"{'testbench compiles against the starter (no reference solution)' if ok else 'testbench does not compile against the starter'}"))
                continue
            if not f:
                print(_c("warn", f"  ! {p.slug} [{lang}] no reference solution"))
                continue
            res = judge.judge(p, lang, f.read_text())
            ok = res["accepted"]
            if ok and (p.category == "debug" or p.meta.get("kind") in ("checker", "testbench")) and p.starter(lang):
                # buggy starters (debug) and empty checkers / testbenches must NOT pass
                if judge.judge(p, lang, p.starter(lang))["accepted"]:
                    ok = False
                    res["verdict"] = "buggy starter is accepted"
            failures += not ok
            print(_c("pass" if ok else "fail",
                     f"  {'✔' if ok else '✘'} {p.slug:<28} {lang:<14} {res['verdict']}")
                  + f"  {res['passed']}/{res['total']}  ({res['seconds']}s)")
            if not ok and args.verbose:
                print_result(res, True)
    print(f"\n{failures} failure(s)")
    return 1 if failures else 0


def _smoke_vhdl_tb(p):
    """Analyze + elaborate the VHDL testbench against the (empty) VHDL starter."""
    import shutil, subprocess, tempfile
    ghdl = tools.find("ghdl")
    if not ghdl:
        return True
    wd = Path(tempfile.mkdtemp(prefix="hwlc-smoke-"))
    try:
        (wd / "design.vhd").write_text(p.starter("vhdl"))
        shutil.copy(p.testbench("vhdl"), wd / "tb.vhd")
        for cmd in (["-a", "--std=08", "design.vhd"], ["-a", "--std=08", "tb.vhd"], ["-e", "--std=08", "tb"]):
            if subprocess.run([ghdl] + cmd, cwd=wd, capture_output=True).returncode:
                return False
        return True
    finally:
        shutil.rmtree(wd, ignore_errors=True)


def cmd_doctor(args):
    print("External tools:")
    for name, info in tools.status().items():
        state = _c("pass", "found  ") if info["path"] else _c("fail", "missing")
        print(f"  {state} {name:<10} {info['version'] or ''}")
        print(f"          {info['purpose']}")
    print(f"\nVerilog/SV simulator: {tools.sv_simulator() or 'none'}  (set HWLC_SV_SIM=verilator to switch)")
    missing = [n for n, i in tools.status().items() if not i["path"]]
    if missing:
        print("\nInstall on Arch:   sudo pacman -S iverilog yosys verilator z3 ccache && yay -S ghdl")
        print("Install on Debian: sudo apt install iverilog yosys verilator z3 ghdl ccache")
    return 0


def cmd_gui(args):
    from . import gui
    return gui.run()


def cmd_gen(args):
    """Regenerate vector testbenches for problems that have a gen.py."""
    from . import vectors
    todo = [p for p in problems.load_all() if (p.path / "gen.py").exists()
            and (not args.problem or p.slug in args.problem)]
    for p in todo:
        n, groups, written = vectors.build(p)
        extra = f", new starters: {', '.join(written)}" if written else ""
        print(f"  {p.slug:<28} {n:>6} vectors, {len(groups)} checks{extra}")
    return 0


def cmd_waves(args):
    """Regenerate waves.json (example waveforms) for problems with a gen.py, without touching testbenches."""
    from . import vectors, waves
    todo = [p for p in problems.load_all() if ((p.path / "gen.py").exists() or p.meta.get("wave_windows"))
            and (not args.problem or p.slug in args.problem)]
    for p in todo:
        if (p.path / "gen.py").exists():
            n = waves.build(p, vectors.load_gen(p))
        else:
            ws = waves.from_vcd(p, p.meta["wave_windows"])
            (p.path / "waves.json").write_text(json.dumps(ws, indent=1) + "\n")
            n = len(ws)
        print(f"  {p.slug:<28} {n} waveform(s)")
    return 0


def cmd_roadmap(args):
    """Show the topic roadmap (docs/roadmap.json) with live status; rewrite docs/ROADMAP.md."""
    road = json.loads((problems.ROOT / "docs" / "roadmap.json").read_text())
    have = {p.slug: p for p in problems.load_all()}
    md = ["# Problem roadmap", "",
          "Generated by `python3 -m hwlc roadmap` from `docs/roadmap.json`.", "",
          "Status: ✅ available · 🔜 planned · ⛔ not possible with the local open-source tools", ""]
    totals = {"done": 0, "planned": 0, "unsupported": 0}
    for cat, items in road.items():
        md += [f"## {cat}", "", "| # | Topic | Difficulty | Status | Problem |", "|---|---|---|---|---|"]
        done = 0
        for i, e in enumerate(items, 1):
            if e["slug"] in have:
                st, icon = "done", "✅"
                where = f"`{e['slug']}` (#{have[e['slug']].id})"
                done += 1
            elif e.get("status") == "unsupported":
                st, icon, where = "unsupported", "⛔", e.get("note", "")
            else:
                st, icon, where = "planned", "🔜", e.get("note", "")
            totals[st] += 1
            md.append(f"| {i} | {e['title']} | {e['difficulty']} | {icon} | {where} |")
        md.append("")
        print(f"  {cat:<40} {done:>3}/{len(items)} available")
    (problems.ROOT / "docs" / "ROADMAP.md").write_text("\n".join(md) + "\n")
    print(f"\n  {totals['done']} available, {totals['planned']} planned, "
          f"{totals['unsupported']} unsupported  ->  docs/ROADMAP.md")
    return 0


def cmd_install_desktop(args):
    """Add an 'HDL Judge' entry to the desktop application menu."""
    root = problems.ROOT
    apps = Path.home() / ".local/share/applications"
    apps.mkdir(parents=True, exist_ok=True)
    entry = apps / "hdl-judge.desktop"
    entry.write_text(
        "[Desktop Entry]\nType=Application\nName=HDL Judge\n"
        "Comment=LeetCode-style Verilog / SystemVerilog / VHDL practice\n"
        f"Exec=sh -c 'cd \"{root}\" && exec python3 -m hwlc gui'\n"
        "Icon=applications-engineering\nTerminal=false\nCategories=Development;Education;\n")
    print(f"installed {entry}")
    return 0


def cmd_serve(args):
    from . import server
    server.serve(args.host, args.port, open_browser=not args.no_browser)


def _problem(slug):
    p = problems.get(slug)
    if not p:
        for q in problems.load_all():
            if str(q.id) == slug:
                return q
        raise SystemExit(f"unknown problem '{slug}' (see `hwlc list`)")
    return p


def main(argv=None):
    ap = argparse.ArgumentParser(prog="hwlc", description="LeetCode-style judge for HDL problems")
    sub = ap.add_subparsers(dest="cmd")

    s = sub.add_parser("gui", help="open the desktop app (default)")
    s.set_defaults(func=cmd_gui)

    s = sub.add_parser("gen", help="(authoring) regenerate vector testbenches from gen.py")
    s.add_argument("problem", nargs="*")
    s.set_defaults(func=cmd_gen)

    s = sub.add_parser("waves", help="(authoring) regenerate example waveforms from gen.py")
    s.add_argument("problem", nargs="*")
    s.set_defaults(func=cmd_waves)

    s = sub.add_parser("roadmap", help="show the topic roadmap and regenerate docs/ROADMAP.md")
    s.set_defaults(func=cmd_roadmap)

    s = sub.add_parser("install-desktop", help="add HDL Judge to the application menu")
    s.set_defaults(func=cmd_install_desktop)

    s = sub.add_parser("serve", help="serve the UI to a web browser instead")
    s.add_argument("--host", default="127.0.0.1")
    s.add_argument("--port", type=int, default=8080)
    s.add_argument("--no-browser", action="store_true")
    s.set_defaults(func=cmd_serve)

    s = sub.add_parser("list", help="list problems")
    s.set_defaults(func=cmd_list)

    s = sub.add_parser("show", help="print a problem statement")
    s.add_argument("problem")
    s.add_argument("--starter", choices=list(problems.LANGUAGES))
    s.set_defaults(func=cmd_show)

    s = sub.add_parser("submit", help="judge a solution file")
    s.add_argument("problem", help="problem slug or id")
    s.add_argument("file")
    s.add_argument("--lang", choices=list(problems.LANGUAGES))
    s.add_argument("--check", action="store_true", help="compile + synthesis only")
    s.add_argument("-v", "--verbose", action="store_true")
    s.add_argument("--json", action="store_true")
    s.add_argument("--keep", action="store_true", help="keep the work directory")
    s.set_defaults(func=cmd_submit)

    s = sub.add_parser("selftest", help="judge all reference solutions")
    s.add_argument("problem", nargs="*")
    s.add_argument("-v", "--verbose", action="store_true")
    s.set_defaults(func=cmd_selftest)

    s = sub.add_parser("doctor", help="check which EDA tools are installed")
    s.set_defaults(func=cmd_doctor)

    args = ap.parse_args(argv)
    if not args.cmd:
        args = ap.parse_args(["gui"])
    return args.func(args) or 0
