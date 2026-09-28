"""Local web server for the browser UI (Python standard library only)."""
import json
import mimetypes
import threading
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse

from . import judge, problems, store, tools

WEB = problems.ROOT / "web"
MAX_BODY = 1 << 20
_judge_slots = threading.BoundedSemaphore(2)   # concurrent judge runs


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
        # (Skipped when the user deliberately binds to a non-loopback address.)
        if self.server.server_address[0] not in ("127.0.0.1", "::1", "localhost"):
            return True
        host = (self.headers.get("Host") or "").rsplit(":", 1)[0].strip("[]")
        return host in ("localhost", "127.0.0.1", "::1")

    # ------------------------------------------------------------ routes
    def do_GET(self):
        if not self._host_ok():
            return self._error(403, "forbidden host")
        path = urlparse(self.path).path
        if path == "/api/problems":
            solved, attempted = store.solved(), store.attempted()
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
            return self._send(200, store.history(slug)[:100])
        if path == "/api/tools":
            return self._send(200, {"tools": tools.status(),
                                    "sv_simulator": tools.sv_simulator()})
        return self._static(path)

    def do_POST(self):
        if not self._host_ok():
            return self._error(403, "forbidden host")
        if urlparse(self.path).path != "/api/judge":
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
            lang, code = req["language"], req["code"]
            mode = req.get("mode", "submit")
        except (ValueError, KeyError, TypeError):
            return self._error(400, "bad request")
        if not p or lang not in p.languages or mode not in ("check", "run", "submit"):
            return self._error(400, "unknown problem or language")
        with _judge_slots:
            result = judge.judge(p, lang, code, mode=mode)
        if mode == "submit":
            store.record(result, code)
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
    missing = [n for n, i in tools.status().items() if not i["path"]]
    if missing:
        print(f"hwlc: missing tools: {', '.join(missing)}  (run `python -m hwlc doctor`)")
    if open_browser:
        threading.Timer(0.5, lambda: webbrowser.open(url)).start()
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nbye")
