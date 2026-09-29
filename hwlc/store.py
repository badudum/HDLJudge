"""Local submission history (data/submissions.jsonl)."""
import json
import threading
import time

from .problems import ROOT

DATA = ROOT / "data"
FILE = DATA / "submissions.jsonl"
_lock = threading.Lock()


def record(result, code, user=""):
    entry = {
        "ts": time.time(), "user": user, "problem": result["problem"], "language": result["language"],
        "verdict": result["verdict"], "passed": result["passed"], "total": result["total"],
        "seconds": result["seconds"], "code": code,
    }
    stats = next((s["details"].get("stats") for s in result["stages"] if s["key"] == "synth"), None)
    if stats:
        entry["cells"] = stats["cells"]
        entry["flip_flops"] = stats["flip_flops"]
    with _lock:
        DATA.mkdir(exist_ok=True)
        with FILE.open("a") as f:
            f.write(json.dumps(entry) + "\n")
    return entry


def history(slug=None, user=None):
    if not FILE.exists():
        return []
    out = []
    with _lock:
        for line in FILE.read_text().splitlines():
            try:
                e = json.loads(line)
            except json.JSONDecodeError:
                continue
            if slug is not None and e["problem"] != slug:
                continue
            if user is not None and e.get("user", "") != user:
                continue
            out.append(e)
    return list(reversed(out))


def solved(user=None):
    return {e["problem"] for e in history(user=user) if e["verdict"] == "Accepted"}


def attempted(user=None):
    return {e["problem"] for e in history(user=user)}
