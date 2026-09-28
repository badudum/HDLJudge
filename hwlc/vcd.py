"""Minimal VCD reader that extracts the testbench-level signals for the web viewer."""
import re

MAX_SIGNALS = 48
MAX_CHANGES = 60000

_UNITS = {"s": 1e15, "ms": 1e12, "us": 1e9, "ns": 1e6, "ps": 1e3, "fs": 1.0}


def _timescale_fs(text):
    m = re.match(r"\s*(\d+)\s*([munpf]?s)", text)
    if not m:
        return 1e3
    return int(m.group(1)) * _UNITS[m.group(2)]


def _is_dut_scope(scope):
    """True for the scope of a design instance: tb.dut, tb.dut1, TOP.tb.dut2, ..."""
    return len(scope) >= 2 and scope[-2] == "tb" and scope[-1].startswith("dut")


def parse(path):
    """Return {"timescale_fs", "end", "signals": [...], "truncated"} or None.

    Only variables declared directly inside a DUT instance (tb.dut*) are kept,
    so the hidden testbench's own variables never reach the user. Signal
    names are prefixed with the instance name when there are several DUTs.
    Times are returned in the file's timescale units.
    """
    try:
        text = open(path, "r", errors="replace").read()
    except OSError:
        return None

    tokens = iter(text.split())
    scope = []
    by_code = {}          # code -> list of signal dicts sharing it
    signals = []
    timescale = 1e3

    for tok in tokens:
        if tok == "$timescale":
            parts = []
            for t in tokens:
                if t == "$end":
                    break
                parts.append(t)
            timescale = _timescale_fs("".join(parts))
        elif tok == "$scope":
            _kind = next(tokens)
            scope.append(next(tokens))
            next(tokens)  # $end
        elif tok == "$upscope":
            if scope:
                scope.pop()
            next(tokens)
        elif tok == "$var":
            parts = []
            for t in tokens:
                if t == "$end":
                    break
                parts.append(t)
            if len(parts) < 4:
                continue
            kind, width, code, name = parts[0], parts[1], parts[2], parts[3]
            rng = "".join(parts[4:])
            if not _is_dut_scope(scope) or len(signals) >= MAX_SIGNALS:
                continue
            is_real = kind in ("real", "realtime") or kind == "real_parameter"
            try:
                width = int(width)
            except ValueError:
                width = 1
            if not rng and "[" in name:
                name, _, rest = name.partition("[")
                rng = "[" + rest
            if width > 64 and not is_real:
                continue
            sig = {"name": name + (rng if width > 1 else ""),
                   "scope": scope[-1],
                   "width": 64 if is_real else width,
                   "kind": "real" if is_real else "bits",
                   "changes": []}
            signals.append(sig)
            by_code.setdefault(code, []).append(sig)
        elif tok == "$enddefinitions":
            next(tokens)
            break

    time = 0
    end = 0
    total = 0
    truncated = False
    pending = None  # for "b0101 code" / "r1.5 code"
    for tok in tokens:
        if pending is not None:
            _record(by_code.get(tok), time, pending)
            pending = None
            total += 1
            continue
        c = tok[0]
        if c == "#":
            try:
                time = int(tok[1:])
                end = max(end, time)
            except ValueError:
                pass
            if total > MAX_CHANGES:
                truncated = True
                break
        elif c in "bBrR":
            pending = tok[1:] if c in "bB" else ("r" + tok[1:])
        elif c in "01xXzZuUwWlLhH-":
            _record(by_code.get(tok[1:]), time, tok[0])
            total += 1
        # $dumpvars / $end / $comment etc. are skipped

    if len({s["scope"] for s in signals}) > 1:
        for s in signals:
            s["name"] = s["scope"] + "." + s["name"]
    for s in signals:
        s["changes"] = _dedupe(s["changes"])
    # parameters / constants (e.g. TAU, WIDTH) never change: leave them out
    signals = [s for s in signals
               if not (len(s["changes"]) <= 1 and re.fullmatch(r"[A-Z][A-Z0-9_]*", s["name"].split(".")[-1]))]
    for s in signals:
        if s["kind"] == "real":
            s["changes"] = [[t, _to_float(v)] for t, v in s["changes"]]
    return {"timescale_fs": timescale, "end": end, "signals": signals,
            "truncated": truncated}


def _record(sigs, time, value):
    if not sigs:
        return
    for s in sigs:
        if value.startswith("r"):
            v = value[1:]
        else:
            v = value.lower()
            if s["kind"] == "bits" and len(v) < s["width"]:
                pad = v[0] if v[0] in "xz" else "0"
                v = pad * (s["width"] - len(v)) + v
        ch = s["changes"]
        if ch and ch[-1][0] == time:
            ch[-1][1] = v
        else:
            ch.append([time, v])


def _dedupe(changes):
    out = []
    for t, v in changes:
        if out and out[-1][1] == v:
            continue
        out.append([t, v])
    return out


def _to_float(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return None
