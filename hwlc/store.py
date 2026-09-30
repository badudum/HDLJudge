"""Local submission history (data/submissions.jsonl)."""
import json
import threading
import time

from .problems import ROOT

DATA = ROOT / "data"
FILE = DATA / "submissions.jsonl"
_lock = threading.Lock()

DRAFTS_FILE = DATA / "drafts.json"
_drafts_lock = threading.Lock()


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


# ---------------------------------------------------------------- drafts
# In-progress (not yet submitted) code, kept server-side per user so it
# survives clearing browser storage or switching devices/browsers.

def _load_drafts():
    if not DRAFTS_FILE.exists():
        return {}
    try:
        return json.loads(DRAFTS_FILE.read_text())
    except json.JSONDecodeError:
        return {}


def save_draft(user, slug, lang, code):
    with _drafts_lock:
        d = _load_drafts()
        d.setdefault(user, {}).setdefault(slug, {})[lang] = code
        DATA.mkdir(exist_ok=True)
        DRAFTS_FILE.write_text(json.dumps(d))


def delete_draft(user, slug, lang):
    with _drafts_lock:
        d = _load_drafts()
        if d.get(user, {}).get(slug, {}).pop(lang, None) is not None:
            if not d[user][slug]:
                del d[user][slug]
            if not d[user]:
                del d[user]
            DATA.mkdir(exist_ok=True)
            DRAFTS_FILE.write_text(json.dumps(d))


def drafts_for(user, slug):
    return _load_drafts().get(user, {}).get(slug, {})
