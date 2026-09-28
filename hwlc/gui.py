"""Desktop window for the judge: the web UI inside a native GTK/WebKit window.

Uses WebKitGTK through PyGObject (GTK 4 + WebKit 6.0, or GTK 3 + WebKit2 4.1).
If neither is available, falls back to opening the UI in the default browser.
"""
import os
import threading
from http.server import ThreadingHTTPServer
from pathlib import Path

from . import server

TITLE = "HDL Judge"
PREFERRED_PORT = 18080   # fixed so drafts in the window's local storage persist across launches
DATA_DIR = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "hwlc"
CACHE_DIR = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "hwlc"


def _start_server():
    for port in (PREFERRED_PORT, 0):
        try:
            httpd = ThreadingHTTPServer(("127.0.0.1", port), server.Handler)
            break
        except OSError:
            continue
    threading.Thread(target=httpd.serve_forever, daemon=True).start()
    return httpd, f"http://localhost:{httpd.server_address[1]}/"


def _gtk4(url):
    import gi
    gi.require_version("Gtk", "4.0")
    gi.require_version("WebKit", "6.0")
    from gi.repository import Gtk, WebKit

    DATA_DIR.mkdir(parents=True, exist_ok=True)
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    session = WebKit.NetworkSession.new(str(DATA_DIR), str(CACHE_DIR))

    app = Gtk.Application(application_id="dev.hwlc.HDLJudge")

    def activate(app):
        win = Gtk.ApplicationWindow(application=app, title=TITLE)
        win.set_default_size(1480, 920)
        view = WebKit.WebView(network_session=session)
        settings = view.get_settings()
        settings.set_enable_developer_extras(True)
        settings.set_javascript_can_access_clipboard(True)
        view.connect("notify::title", lambda v, _p: win.set_title(v.get_title() or TITLE))
        view.load_uri(url)
        win.set_child(view)
        win.maximize()
        win.present()

    app.connect("activate", activate)
    return app.run(None)


def _gtk3(url):
    import gi
    gi.require_version("Gtk", "3.0")
    gi.require_version("WebKit2", "4.1")
    from gi.repository import Gtk, WebKit2

    DATA_DIR.mkdir(parents=True, exist_ok=True)
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    manager = WebKit2.WebsiteDataManager(base_data_directory=str(DATA_DIR),
                                         base_cache_directory=str(CACHE_DIR))
    ctx = WebKit2.WebContext.new_with_website_data_manager(manager)
    win = Gtk.Window(title=TITLE)
    win.set_default_size(1480, 920)
    view = WebKit2.WebView.new_with_context(ctx)
    view.connect("notify::title", lambda v, _p: win.set_title(v.get_title() or TITLE))
    view.load_uri(url)
    win.add(view)
    win.connect("destroy", Gtk.main_quit)
    win.maximize()
    win.show_all()
    Gtk.main()
    return 0


def run():
    httpd, url = _start_server()
    print(f"hwlc: judge server on {url}")
    try:
        for backend in (_gtk4, _gtk3):
            try:
                return backend(url)
            except (ImportError, ValueError) as e:     # gi missing / version unavailable
                last = e
        print(f"hwlc: no WebKitGTK found ({last}); opening the browser instead")
        import webbrowser
        webbrowser.open(url)
        print("hwlc: press Ctrl+C to stop")
        threading.Event().wait()
    except KeyboardInterrupt:
        pass
    finally:
        httpd.shutdown()
    return 0

