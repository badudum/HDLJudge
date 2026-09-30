"""Local web server for the browser UI (Python standard library only)."""
import base64
import hmac
import json
import mimetypes
import os
import threading
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse

from . import judge, problems, store, tools

WEB = problems.ROOT / "web"
MAX_BODY = 1 << 20
_judge_slots = threading.BoundedSemaphore(2)   # concurrent judge runs

# Optional HTTP Basic Auth gate, meant for when the server is reachable from
# outside localhost (e.g. behind a Tailscale Funnel). Off by default so plain
# `hwlc serve` on localhost is unchanged. Each authenticated user also gets
# their own submission history (solved status, past code) via HWLC_AUTH_USERS,
# a comma-separated list of "user:password" pairs, e.g. "ann:hunter2,bob:swordfish".
def _load_users():
    raw = os.environ.get("HWLC_AUTH_USERS", "")
    users = {}
    for pair in raw.split(","):
        pair = pair.strip()
        if not pair or ":" not in pair:
            continue
        name, _, pw = pair.partition(":")
        if name:
            users[name] = pw
    return users


_AUTH_USERS = _load_users()

# Usernames (from HWLC_AUTH_USERS) that can log in and judge code normally,
# but whose submissions, solved status and drafts are never written to
# disk - a shared "guest" / "trial" login that leaves no trace and can't
# see a previous guest's leftovers either.
_GUEST_USERS = {u.strip() for u in os.environ.get("HWLC_GUEST_USERS", "").split(",") if u.strip()}


class Handler(BaseHTTPRequestHandler):
    server_version = "hwlc"

    def log_message(self, fmt, *args):
        pass

    # ------------------------------------------------------------ plumbing
    def _send(self, code, body, ctype="application/json"):
        data = body if isinstance(body, bytes) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(data)

    def _error(self, code, msg):
        self._send(code, {"error": msg})

    def _host_ok(self):
        # Reject DNS-rebinding style requests: only answer to local host names.
        # (Skipped when the user deliberately binds to a non-loopback address, or
        # has put the server behind an auth gate / reverse proxy such as a
        # Tailscale Funnel, which forwards the public hostname as Host.)
        if self.server.server_address[0] not in ("127.0.0.1", "::1", "localhost"):
            return True
        if _AUTH_USERS:
            return True
        host = (self.headers.get("Host") or "").rsplit(":", 1)[0].strip("[]")
        return host in ("localhost", "127.0.0.1", "::1")

    def _authenticated_user(self):
        """Returns the logged-in username, "" if auth is off, or None if the
        request's credentials are missing/wrong."""
        if not _AUTH_USERS:
            return ""
        given = self.headers.get("Authorization") or ""
        if not given.startswith("Basic "):
            return None
        try:
            name, _, pw = base64.b64decode(given[6:]).decode().partition(":")
        except (ValueError, UnicodeDecodeError):
            return None
        expected = _AUTH_USERS.get(name)
        if expected is not None and hmac.compare_digest(pw, expected):
            return name
        return None

    def _require_auth(self):
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="HDL Judge"')
        self.send_header("Content-Type", "application/json")
        body = json.dumps({"error": "authentication required"}).encode()
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    # ------------------------------------------------------------ routes
    def do_GET(self):
        if not self._host_ok():
            return self._error(403, "forbidden host")
        user = self._authenticated_user()
        if user is None:
            return self._require_auth()
        path = urlparse(self.path).path
        if path == "/api/problems":
            solved, attempted = store.solved(user), store.attempted(user)
            out = []
            for p in problems.load_all():
                d = p.summary()
                d["status"] = ("solved" if p.slug in solved
                               else "attempted" if p.slug in attempted else "todo")
                out.append(d)
            return self._send(200, out)
        if path.startswith("/api/problems/"):
            p = problems.get(path.rsplit("/", 1)[1])
            return self._send(200, p.detail()) if p else self._error(404, "no such problem")
        if path.startswith("/api/submissions/"):
            slug = path.rsplit("/", 1)[1]
            return self._send(200, store.history(slug, user)[:100])
        if path.startswith("/api/draft/"):
            slug = path.rsplit("/", 1)[1]
            return self._send(200, store.drafts_for(user, slug))
        if path == "/api/tools":
            return self._send(200, {"tools": tools.status(),
                                    "sv_simulator": tools.sv_simulator()})
        return self._static(path)

    def do_POST(self):
        if not self._host_ok():
            return self._error(403, "forbidden host")
        user = self._authenticated_user()
        if user is None:
            return self._require_auth()
        path = urlparse(self.path).path
        if path not in ("/api/judge", "/api/draft"):
            return self._error(404, "not found")
        # requiring JSON forces a CORS preflight, so other web pages cannot post here
        if not (self.headers.get("Content-Type") or "").startswith("application/json"):
            return self._error(415, "expected application/json")
        length = int(self.headers.get("Content-Length") or 0)
        if length > MAX_BODY:
            return self._error(413, "code too large")
        try:
            req = json.loads(self.rfile.read(length))
            p = problems.get(req["problem"])
            lang = req["language"]
        except (ValueError, KeyError, TypeError):
            return self._error(400, "bad request")
        if not p or lang not in p.languages:
            return self._error(400, "unknown problem or language")
        if path == "/api/draft":
            code = req.get("code")
            if user not in _GUEST_USERS:
                if code is None:
                    store.delete_draft(user, p.slug, lang)
                elif isinstance(code, str):
                    store.save_draft(user, p.slug, lang, code)
                else:
                    return self._error(400, "bad request")
            elif code is not None and not isinstance(code, str):
                return self._error(400, "bad request")
            return self._send(200, {"ok": True})
        try:
            code = req["code"]
            mode = req.get("mode", "submit")
        except KeyError:
            return self._error(400, "bad request")
        if mode not in ("check", "run", "submit"):
            return self._error(400, "unknown problem or language")
        with _judge_slots:
            result = judge.judge(p, lang, code, mode=mode)
        if mode == "submit" and user not in _GUEST_USERS:
            store.record(result, code, user)
        return self._send(200, result)

    def _static(self, path):
        if path in ("", "/"):
            path = "/index.html"
        target = (WEB / path.lstrip("/")).resolve()
        if WEB.resolve() not in target.parents or not target.is_file():
            return self._error(404, "not found")
        ctype = mimetypes.guess_type(target.name)[0] or "application/octet-stream"
        return self._send(200, target.read_bytes(), ctype)


def serve(host="127.0.0.1", port=8080, open_browser=True):
    httpd = ThreadingHTTPServer((host, port), Handler)
    url = f"http://{'localhost' if host in ('127.0.0.1', '0.0.0.0') else host}:{port}/"
    print(f"hwlc: serving {len(problems.load_all())} problems at {url}  (Ctrl+C to stop)")
    if _AUTH_USERS:
        print(f"hwlc: HTTP Basic Auth enabled (users: {', '.join(sorted(_AUTH_USERS))})")
        if _GUEST_USERS:
            print(f"hwlc: non-persistent guest users: {', '.join(sorted(_GUEST_USERS))}")
    elif host not in ("127.0.0.1", "::1", "localhost"):
        print("hwlc: WARNING: bound to a non-loopback address with no auth configured "
              "(set HWLC_AUTH_USERS)")
    missing = [n for n, i in tools.status().items() if not i["path"]]
    if missing:
        print(f"hwlc: missing tools: {', '.join(missing)}  (run `python -m hwlc doctor`)")
    if open_browser:
        threading.Timer(0.5, lambda: webbrowser.open(url)).start()
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nbye")
