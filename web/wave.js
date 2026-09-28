// Canvas waveform viewer for the judge's simplified VCD data.
// Wheel = zoom around the mouse, drag = pan, move = cursor with values.
(function () {
  const ROW = 26, REAL_ROW = 64, AXIS = 26;

  function css(name) {
    return getComputedStyle(document.documentElement).getPropertyValue(name).trim();
  }

  function bitsToHex(v) {
    if (/[xX]/.test(v)) return "x";
    if (/[zZ]/.test(v)) return "z";
    if (/[^01]/.test(v)) return "?";
    let out = "";
    for (let i = v.length; i > 0; i -= 4) {
      out = parseInt(v.slice(Math.max(0, i - 4), i), 2).toString(16) + out;
    }
    return out.replace(/^0+(?=.)/, "");
  }

  function fmtReal(x) {
    if (x === null || x === undefined) return "?";
    const a = Math.abs(x);
    if (a !== 0 && (a < 1e-3 || a >= 1e5)) return x.toExponential(3);
    return (+x.toPrecision(5)).toString();
  }

  function fmtTime(fs) {
    const units = [["s", 1e15], ["ms", 1e12], ["us", 1e9], ["ns", 1e6], ["ps", 1e3], ["fs", 1]];
    for (const [u, f] of units) {
      if (Math.abs(fs) >= f || u === "fs") return (+(fs / f).toPrecision(6)) + " " + u;
    }
  }

  // index of the last change at or before time t
  function idxAt(ch, t) {
    let lo = 0, hi = ch.length - 1, ans = -1;
    while (lo <= hi) {
      const mid = (lo + hi) >> 1;
      if (ch[mid][0] <= t) { ans = mid; lo = mid + 1; } else hi = mid - 1;
    }
    return ans;
  }

  function valueText(sig, v) {
    if (v === undefined) return "";
    if (sig.kind === "real") return fmtReal(v);
    if (sig.width === 1) return v;
    return bitsToHex(v);
  }

  function WaveViewer(container, data) {
    this.c = container;
    this.data = data;
    this.sigs = data.signals;
    this.end = Math.max(data.end, 1);
    this.t0 = 0;
    this.t1 = this.end;
    this.cursor = null;
    this.build();
  }

  WaveViewer.prototype.build = function () {
    const c = this.c;
    c.innerHTML = "";
    if (!this.sigs.length) {
      c.innerHTML = '<p class="wave-empty muted">No signals were recorded.</p>';
      return;
    }
    const tb = document.createElement("div");
    tb.className = "wave-toolbar";
    tb.innerHTML = '<button data-z="in" title="Zoom in">＋</button><button data-z="out" title="Zoom out">－</button>' +
      '<button data-z="fit">Fit</button><span class="cursor-time"></span><span class="spacer"></span>' +
      '<span class="muted" style="font-size:12px">wheel: zoom · drag: pan</span>';
    c.appendChild(tb);
    this.timeLabel = tb.querySelector(".cursor-time");
    tb.addEventListener("click", e => {
      const z = e.target.dataset.z;
      if (z === "in") this.zoom(0.5, (this.t0 + this.t1) / 2);
      if (z === "out") this.zoom(2, (this.t0 + this.t1) / 2);
      if (z === "fit") { this.t0 = 0; this.t1 = this.end; this.draw(); }
    });
    if (this.data.truncated) {
      const n = document.createElement("span");
      n.className = "muted"; n.style.fontSize = "12px";
      n.textContent = "(trace truncated)";
      tb.insertBefore(n, tb.querySelector(".spacer"));
    }

    const body = document.createElement("div");
    body.className = "wave-body";
    const names = document.createElement("div");
    names.className = "wave-names";
    const wrap = document.createElement("div");
    wrap.className = "wave-canvas-wrap";
    const canvas = document.createElement("canvas");
    wrap.appendChild(canvas);
    body.appendChild(names);
    body.appendChild(wrap);
    c.appendChild(body);
    this.canvas = canvas;
    this.wrap = wrap;

    const sp = document.createElement("div");
    sp.className = "axis-spacer";
    sp.style.height = AXIS + "px";
    names.appendChild(sp);
    this.valueEls = [];
    this.rows = [];
    let y = AXIS;
    for (const s of this.sigs) {
      const h = s.kind === "real" ? REAL_ROW : ROW;
      const el = document.createElement("div");
      el.className = "wn";
      el.style.height = h + "px";
      el.innerHTML = '<span class="nm"></span><span class="vl"></span>';
      el.querySelector(".nm").textContent = s.name;
      el.title = s.name;
      names.appendChild(el);
      this.valueEls.push(el.querySelector(".vl"));
      this.rows.push({ y, h });
      y += h;
      if (s.kind === "real") {
        let lo = Infinity, hi = -Infinity;
        for (const [, v] of s.changes) if (v !== null) { lo = Math.min(lo, v); hi = Math.max(hi, v); }
        if (!isFinite(lo)) { lo = 0; hi = 1; }
        if (hi - lo < 1e-12) { hi += 0.5; lo -= 0.5; }
        s._lo = lo; s._hi = hi;
      }
    }
    this.height = y + 4;

    let drag = null;
    canvas.addEventListener("wheel", e => {
      e.preventDefault();
      this.zoom(e.deltaY < 0 ? 0.8 : 1.25, this.xToT(e.offsetX));
    }, { passive: false });
    canvas.addEventListener("mousedown", e => { drag = { x: e.clientX, t0: this.t0, t1: this.t1 }; });
    window.addEventListener("mouseup", () => { drag = null; });
    canvas.addEventListener("mousemove", e => {
      if (drag) {
        const dt = (e.clientX - drag.x) / this.w * (drag.t1 - drag.t0);
        this.pan(drag.t0 - dt, drag.t1 - dt);
      }
      this.cursor = this.xToT(e.offsetX);
      this.draw();
    });
    canvas.addEventListener("mouseleave", () => { this.cursor = null; this.draw(); });
    this.ro = new ResizeObserver(() => this.draw());
    this.ro.observe(wrap);
    this.draw();
  };

  WaveViewer.prototype.xToT = function (x) { return this.t0 + x / this.w * (this.t1 - this.t0); };
  WaveViewer.prototype.tToX = function (t) { return (t - this.t0) / (this.t1 - this.t0) * this.w; };

  WaveViewer.prototype.zoom = function (f, center) {
    let span = Math.max((this.t1 - this.t0) * f, 4);
    span = Math.min(span, this.end);
    const r = (center - this.t0) / (this.t1 - this.t0);
    this.pan(center - r * span, center - r * span + span);
  };

  WaveViewer.prototype.pan = function (a, b) {
    const span = b - a;
    if (a < 0) { a = 0; b = span; }
    if (b > this.end) { b = this.end; a = Math.max(0, b - span); }
    this.t0 = a; this.t1 = b;
    this.draw();
  };

  WaveViewer.prototype.draw = function () {
    if (!this.canvas) return;
    const dpr = window.devicePixelRatio || 1;
    const w = this.wrap.clientWidth;
    if (!w) return;
    this.w = w;
    const h = this.height;
    const cv = this.canvas;
    if (cv.width !== w * dpr || cv.height !== h * dpr) {
      cv.width = w * dpr; cv.height = h * dpr;
      cv.style.width = w + "px"; cv.style.height = h + "px";
    }
    const g = cv.getContext("2d");
    g.setTransform(dpr, 0, 0, dpr, 0, 0);
    const col = {
      bg: css("--wave-bg"), grid: css("--wave-grid"), line: css("--wave-line"), bus: css("--wave-bus"),
      real: css("--wave-real"), x: css("--wave-x"), z: css("--wave-z"), text: css("--text"),
      muted: css("--muted"), cursor: css("--wave-cursor"), border: css("--border"),
    };
    g.fillStyle = col.bg;
    g.fillRect(0, 0, w, h);
    g.font = "11px ui-monospace, Menlo, Consolas, monospace";
    g.textBaseline = "middle";

    // time axis + grid
    const tsf = this.data.timescale_fs;
    const spanFs = (this.t1 - this.t0) * tsf;
    const rawStep = spanFs / Math.max(2, w / 110);
    const p10 = Math.pow(10, Math.floor(Math.log10(rawStep)));
    const step = [1, 2, 5, 10].map(m => m * p10).find(s => s >= rawStep);
    const startFs = Math.ceil(this.t0 * tsf / step) * step;
    g.fillStyle = col.muted;
    for (let fs = startFs; fs <= this.t1 * tsf; fs += step) {
      const x = Math.round(this.tToX(fs / tsf)) + 0.5;
      g.strokeStyle = col.grid;
      g.beginPath(); g.moveTo(x, AXIS); g.lineTo(x, h); g.stroke();
      g.strokeStyle = col.border;
      g.beginPath(); g.moveTo(x, AXIS - 6); g.lineTo(x, AXIS); g.stroke();
      g.fillText(fmtTime(fs), x + 3, AXIS / 2);
    }
    g.strokeStyle = col.border;
    g.beginPath(); g.moveTo(0, AXIS - 0.5); g.lineTo(w, AXIS - 0.5); g.stroke();

    this.sigs.forEach((s, i) => {
      const { y, h: rh } = this.rows[i];
      g.strokeStyle = col.grid;
      g.beginPath(); g.moveTo(0, y + rh - 0.5); g.lineTo(w, y + rh - 0.5); g.stroke();
      if (s.kind === "real") this.drawReal(g, s, y, rh, col);
      else if (s.width === 1) this.drawBit(g, s, y, rh, col);
      else this.drawBus(g, s, y, rh, col);
    });

    // cursor
    if (this.cursor !== null) {
      const x = Math.round(this.tToX(this.cursor)) + 0.5;
      g.strokeStyle = col.cursor;
      g.beginPath(); g.moveTo(x, 0); g.lineTo(x, h); g.stroke();
      this.timeLabel.textContent = "t = " + fmtTime(this.cursor * tsf);
    } else {
      this.timeLabel.textContent = "";
    }
    const tv = this.cursor === null ? this.t1 : this.cursor;
    this.sigs.forEach((s, i) => {
      const k = idxAt(s.changes, tv);
      this.valueEls[i].textContent = k < 0 ? "" : valueText(s, s.changes[k][1]);
    });
  };

  // iterate visible segments [xa, xb) with their value
  WaveViewer.prototype.segments = function (s, fn) {
    const ch = s.changes;
    let k = Math.max(0, idxAt(ch, this.t0));
    for (; k < ch.length; k++) {
      const ta = ch[k][0];
      if (ta > this.t1) break;
      const tb = k + 1 < ch.length ? ch[k + 1][0] : this.end;
      fn(Math.max(0, this.tToX(ta)), Math.min(this.w, this.tToX(tb)), ch[k][1], ta);
    }
  };

  WaveViewer.prototype.drawBit = function (g, s, y, rh, col) {
    const hi = y + 5, lo = y + rh - 5;
    let prevY = null;
    this.segments(s, (xa, xb, v) => {
      if (v === "1" || v === "0" || v === "h" || v === "l") {
        const yy = (v === "1" || v === "h") ? hi : lo;
        g.strokeStyle = col.line;
        g.beginPath();
        if (prevY !== null && prevY !== yy) { g.moveTo(xa + 0.5, prevY); g.lineTo(xa + 0.5, yy); }
        else g.moveTo(xa, yy);
        g.lineTo(xb, yy);
        g.stroke();
        if (yy === hi) {
          g.fillStyle = col.line + "22";
          g.fillRect(xa, hi, xb - xa, lo - hi);
        }
        prevY = yy;
      } else {
        const c = v === "z" ? col.z : col.x;
        g.fillStyle = c + "44";
        g.fillRect(xa, hi, Math.max(1, xb - xa), lo - hi);
        g.strokeStyle = c;
        g.beginPath(); g.moveTo(xa, (hi + lo) / 2); g.lineTo(xb, (hi + lo) / 2); g.stroke();
        prevY = null;
      }
    });
  };

  WaveViewer.prototype.drawBus = function (g, s, y, rh, col) {
    const top = y + 5, bot = y + rh - 5, mid = (top + bot) / 2;
    this.segments(s, (xa, xb, v) => {
      const txt = bitsToHex(v);
      const bad = txt === "x" || txt === "?" || txt === "z";
      const c = bad ? (txt === "z" ? col.z : col.x) : col.bus;
      const e = Math.min(3, (xb - xa) / 2);
      g.strokeStyle = c;
      g.fillStyle = c + (bad ? "33" : "18");
      g.beginPath();
      g.moveTo(xa, mid); g.lineTo(xa + e, top); g.lineTo(xb - e, top); g.lineTo(xb, mid);
      g.lineTo(xb - e, bot); g.lineTo(xa + e, bot); g.closePath();
      g.fill(); g.stroke();
      const room = xb - xa - 8;
      if (room > 10) {
        g.fillStyle = col.text;
        let t = txt;
        while (t.length > 1 && g.measureText(t).width > room) t = t.slice(0, -2) + "…";
        if (g.measureText(t).width <= room) g.fillText(t, xa + 5, mid);
      }
    });
  };

  WaveViewer.prototype.drawReal = function (g, s, y, rh, col) {
    const top = y + 6, bot = y + rh - 6;
    const sc = v => bot - (v - s._lo) / (s._hi - s._lo) * (bot - top);
    g.fillStyle = col.muted;
    g.fillText(fmtReal(s._hi), 3, top + 4);
    g.fillText(fmtReal(s._lo), 3, bot - 4);
    g.strokeStyle = col.real;
    g.lineWidth = 1.5;
    g.beginPath();
    let started = false;
    this.segments(s, (xa, xb, v) => {
      if (v === null) { started = false; return; }
      const yy = sc(v);
      if (!started) { g.moveTo(xa, yy); started = true; } else g.lineTo(xa, yy);
      g.lineTo(xb, yy);
    });
    g.stroke();
    g.lineWidth = 1;
  };

  WaveViewer.prototype.destroy = function () { if (this.ro) this.ro.disconnect(); };

  window.WaveViewer = WaveViewer;
})();
