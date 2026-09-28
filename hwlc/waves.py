"""Example waveforms for problem statements.

A problem may have problems/<slug>/waves.json: a list of waveforms shown under the statement
(SVG in the GUI, ASCII in `hwlc show`). `hwlc gen` writes it from gen.py (vectors or checker
traces); hand-written testbench problems can author it directly.

Format of one waveform:

    {"title": "...", "caption": "...",
     "unit": 2,            # time units per clock period (0 = combinational: one column per case)
     "length": T,          # number of time units
     "signals": [{"name": "clk", "kind": "clk"},
                 {"name": "en", "kind": "bit", "values": [0, 0, 1, ...]},        # 0 / 1 / "x"
                 {"name": "count", "kind": "bus", "values": ["0", "0", "1", ...]}, # labels, "x" = don't care
                 {"name": "vout", "kind": "real", "values": [0.0, 0.1, ...]}]}

Each value list has one entry per time unit. With unit = 2 the clock is low for the first unit
and rises in the middle of each period: inputs change at falling edges, registered outputs right
after rising edges.

gen.py can steer the choice with

    WAVES = [{"check": "counts up", "skip": 0, "n": 12, "title": "...", "signals": ["clk", "en", "count"]}]

otherwise the checks named by the problem's examples are used (random checks last).
"""
import json

MAX_WAVES = 2


def _label(v, width):
    if v is None:
        return "x"
    if width <= 4:
        return str(v)
    return format(v, "X")


def _choose_checks(problem, names):
    """Group names to draw, in example order (random / exhaustive checks only as a fallback)."""
    picked = []
    for ex in problem.examples:
        for g in names:
            if g.startswith(ex["check"]) and g not in picked:
                picked.append(g)
                break
    good = [g for g in picked if "random" not in g.lower()]
    rest = [g for g in names if g not in picked and "random" not in g.lower()]
    order = good + rest + [g for g in picked if g not in good]
    return order or names[:1]


def from_vectors(problem, gen, n_clocked=12, n_comb=8):
    clock = getattr(gen, "CLOCK", None)
    ports = [p for p in problem.ports if p["name"] != clock]
    ins = [p for p in ports if p["dir"] == "input"]
    outs = [p for p in ports if p["dir"] == "output"]
    vecs = list(gen.vectors())
    names = []
    for name, _, _ in vecs:
        if name not in names:
            names.append(name)
    cfgs = getattr(gen, "WAVES", None)
    if cfgs is None:
        cfgs = [{"check": g} for g in _choose_checks(problem, names)]
        auto = True
    else:
        auto = False
    waves, used = [], set()
    for cfg in cfgs:
        idx = [i for i, v in enumerate(vecs) if v[0].startswith(cfg["check"])]
        if not idx:
            raise ValueError(f"WAVES: no check starting with {cfg['check']!r}")
        first = idx[0] + cfg.get("skip", 0)
        if first in used and "skip" not in cfg:
            continue
        n = cfg.get("n", n_clocked if clock else n_comb)
        sel = list(range(first, min(first + n, len(vecs))))    # time is continuous across checks
        used.update(sel)
        wave = _clocked(vecs, sel, clock, ins, outs) if clock else _comb(vecs, sel, ins, outs)
        wave["title"] = cfg.get("title", vecs[first][0])
        if cfg.get("signals"):
            order = cfg["signals"]
            wave["signals"] = sorted([s for s in wave["signals"] if s["name"] in order], key=lambda s: order.index(s["name"]))
        waves.append(wave)
        if auto and len(waves) == MAX_WAVES:
            break
    return waves


def _sig(port, values):
    if port.get("type") == "real":
        return {"name": port["name"], "kind": "real", "values": [None if v is None else float(v) for v in values]}
    if port["width"] == 1:
        return {"name": port["name"], "kind": "bit", "values": ["x" if v is None else int(v) & 1 for v in values]}
    return {"name": port["name"], "kind": "bus", "values": [_label(v, port["width"]) for v in values]}


def _val(d, port, default):
    v = d.get(port["name"], default)
    if isinstance(v, tuple):          # (value, mask): show the checked bits only when fully checked
        v = v[0] if v[1] == (1 << port["width"]) - 1 else None
    return v


def _clocked(vecs, sel, clock, ins, outs):
    n = len(sel)
    T = 2 * n + 1
    sigs = [{"name": clock, "kind": "clk"}]
    for p in ins:
        vals = []
        for k in range(T):
            i = sel[min(k // 2, n - 1)]
            vals.append(_val(vecs[i][1], p, 0))
        sigs.append(_sig(p, vals))
    for p in outs:
        before = _val(vecs[sel[0] - 1][2], p, None) if sel[0] > 0 else None
        vals = []
        for k in range(T):
            if k == 0:
                vals.append(before)
            else:
                i = sel[min((k - 1) // 2, n - 1)]
                vals.append(_val(vecs[i][2], p, None))
        sigs.append(_sig(p, vals))
    return {"unit": 2, "length": T, "signals": sigs,
            "caption": "Inputs change at falling clock edges; outputs are shown after each rising edge "
                       "(x = not checked). Bus values in hex."}


def _comb(vecs, sel, ins, outs):
    sigs = []
    for p in ins:
        sigs.append(_sig(p, [_val(vecs[i][1], p, 0) for i in sel]))
    for p in outs:
        sigs.append(_sig(p, [_val(vecs[i][2], p, None) for i in sel]))
    return {"unit": 0, "length": len(sel), "signals": sigs,
            "caption": "Combinational: each column is one input combination and the resulting outputs. Bus values in hex."}


def from_traces(problem, gen):
    clock = getattr(gen, "CLOCK", "clk")
    ports = [p for p in problem.ports if p["name"] != clock]
    traces = gen.TRACES
    picked = []
    for ex in problem.examples:
        for t in traces:
            if t[0].startswith(ex["check"]) and t not in picked:
                picked.append(t)
                break
    # prefer one legal and one violating trace
    legal = [t for t in picked if not t[1]] or [t for t in traces if not t[1]]
    viol = [t for t in picked if t[1]] or [t for t in traces if t[1]]
    chosen = (legal[:1] + viol[:1]) or traces[:MAX_WAVES]
    waves = []
    for name, violation, sigs in chosen:
        seqs = {k: ([int(c) for c in v] if isinstance(v, str) else list(v)) for k, v in sigs.items()}
        n = max(len(v) for v in seqs.values()) + 1
        T = 2 * n
        out = [{"name": clock, "kind": "clk"}]
        for p in ports:
            seq = seqs.get(p["name"], [0])
            vals = [seq[min(k // 2, len(seq) - 1)] for k in range(T)]
            out.append(_sig(p, vals))
        waves.append({"unit": 2, "length": T, "signals": out, "title": name,
                      "caption": ("VIOLATION: your checker must report an error on this trace."
                                  if violation else "Legal trace: your checker must stay silent.")
                      + " Signals change at falling edges and are sampled at rising edges."})
    return waves


def from_vcd(problem, windows):
    """Waveforms cut from a simulation of the reference solution (for hand-written testbenches).

    windows: [{"from": ns, "to": ns, "step": ns, "clock": "clk", "signals": [...], "title": .., "caption": ..}]
    Each signal is sampled in the middle of every `step`-ns slot.
    """
    import shutil
    from . import judge, vcd
    lang = next((l for l in ("verilog", "systemverilog", "vhdl") if l in problem.languages and problem.solution_file(l)), None)
    if lang is None:
        raise ValueError(f"{problem.slug}: no reference solution to simulate")
    res = judge.judge(problem, lang, problem.solution_file(lang).read_text(), "submit", keep=True)
    wd = res.get("workdir")
    try:
        data = vcd.parse(f"{wd}/wave.vcd") if wd else None
    finally:
        if wd:
            shutil.rmtree(wd, ignore_errors=True)
    if not data:
        raise ValueError(f"{problem.slug}: the reference run produced no waveform ({res['verdict']})")
    return cut(data, windows, [p["name"] for p in problem.ports], problem.slug)


def cut(data, windows, port_names, what=""):
    """Sample windows of a parsed VCD (hwlc.vcd.parse) into waveforms."""
    per_ns = 1e6 / data["timescale_fs"]                  # VCD time units per ns
    import re
    by_name = {re.sub(r"\[\d+:\d+\]$", "", s["name"]): s for s in data["signals"]}
    waves = []
    for w in windows:
        names = w.get("signals") or [n if n in by_name else f"dut1.{n}:{n}" for n in port_names
                                     if n in by_name or f"dut1.{n}" in by_name]
        if not names:
            raise ValueError(f"{what}: no port found in the VCD (have {sorted(by_name)})")
        step = w.get("step", 5)
        T = int(round((w["to"] - w["from"]) / step))
        sigs = []
        for spec in names:
            n, _, shown = spec.partition(":")
            s = by_name.get(n)
            if s is None:
                raise ValueError(f"{what}: signal {n!r} not in the VCD (have {sorted(by_name)})")
            vals = []
            for k in range(T):
                t = (w["from"] + (k + 0.5) * step) * per_ns
                v = None
                for ct, cv in s["changes"]:
                    if ct > t:
                        break
                    v = cv
                vals.append(v)
            label = shown or n
            if s["kind"] == "real":
                sigs.append({"name": label, "kind": "real", "values": vals})
            elif s.get("width", 1) == 1:
                sigs.append({"name": label, "kind": "clk" if n == w.get("clock") else "bit",
                             "values": ["x" if v in (None, "x", "z") else int(v) for v in vals]})
            else:
                lab = []
                for v in vals:
                    if v is None or any(c in "xz" for c in v):
                        lab.append("x")
                    else:
                        iv = int(v, 2)
                        lab.append(_label(iv, s["width"]))
                sigs.append({"name": label, "kind": "bus", "values": lab})
        waves.append({"unit": w.get("unit", 2), "length": T, "signals": sigs, "title": w.get("title", ""),
                      "caption": w.get("caption", "From a simulation of a correct design. Bus values in hex.")})
    return waves


def build(problem, gen):
    """Compute and write waves.json for a generated problem. Returns the number of waveforms."""
    waves = from_traces(problem, gen) if hasattr(gen, "TRACES") else from_vectors(problem, gen)
    (problem.path / "waves.json").write_text(json.dumps(waves, indent=1) + "\n")
    return len(waves)


def load(problem):
    f = problem.path / "waves.json"
    return json.loads(f.read_text()) if f.exists() else []


# ------------------------------------------------------------------ ASCII rendering

def _fmt_real(v):
    return "x" if v is None else f"{v:.3g}"


def ascii(wave):
    T = wave["length"]
    sigs = wave["signals"]
    labels = [str(v) for s in sigs if s["kind"] == "bus" for v in s["values"]]
    labels += [_fmt_real(v) for s in sigs if s["kind"] == "real" for v in s["values"]]
    comb = wave["unit"] == 0
    if comb or wave["unit"] == 1:
        w = max([2] + [len(l) + 1 for l in labels])
    else:
        w = max(2, (max([0] + [len(l) for l in labels]) + 2) // 2)
    name_w = max(len(s["name"]) for s in sigs) + 2
    lines = [f"{wave.get('title', '')}"]
    for s in sigs:
        row = []
        if s["kind"] == "clk" and "values" not in s:
            for k in range(T):
                row.append(("_" if k % 2 == 0 else "‾") * w)
        elif s["kind"] in ("bit", "clk"):
            for v in s["values"]:
                row.append(("x" if v == "x" else "‾" if v else "_") * w)
        else:
            vals = [(_fmt_real(v) if s["kind"] == "real" else str(v)) for v in s["values"]]
            k = 0
            while k < T:
                j = k
                while j + 1 < T and vals[j + 1] == vals[k]:
                    j += 1
                span = w * (j - k + 1)
                txt = vals[k]
                seg = ("|" + txt)[:span].ljust(span, " ") if span > 1 else "|"
                row.append(seg)
                k = j + 1
        lines.append(s["name"].ljust(name_w) + "".join(row))
    if wave.get("caption"):
        lines.append("  " + wave["caption"])
    return "\n".join(lines)
