// HDL Judge front end — LeetCode-style workspace.
(function () {
  "use strict";
  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));
  const LANG_LABEL = { verilog: "Verilog", systemverilog: "SystemVerilog", vhdl: "VHDL" };
  const CAT_LABEL = {
    digital: "Digital", modeling: "Analog / model", arch: "Comp arch", verification: "Verification",
    timing: "Timing", dft: "DFT", debug: "Debug", lowpower: "Low power",
  };
  const catLabel = c => CAT_LABEL[c] || c;
  const CM_MODE = { verilog: "text/x-verilog", systemverilog: "text/x-systemverilog", vhdl: "text/x-vhdl" };
  const icon = (name, cls = "") => `<svg class="${cls}"><use href="#i-${name}"/></svg>`;
  const sico = st => `<span class="sico ${st}">${st === "pass" ? icon("tick") : st === "fail" ? icon("x") : st === "warn" ? "!" : st === "info" ? "i" : "–"}</span>`;

  const store = {
    get(k, d) { try { const v = localStorage.getItem(k); return v === null ? d : v; } catch (e) { return d; } },
    set(k, v) { try { localStorage.setItem(k, v); } catch (e) { /* storage unavailable */ } },
    del(k) { try { localStorage.removeItem(k); } catch (e) { /* storage unavailable */ } },
  };

  function esc(s) {
    return String(s ?? "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
  }

  async function api(path, body) {
    const opt = body ? { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) } : {};
    const r = await fetch(path, opt);
    const data = await r.json();
    if (!r.ok) throw new Error(data.error || r.statusText);
    return data;
  }

  let problemsCache = null;
  async function loadProblems(force) {
    if (!problemsCache || force) problemsCache = await api("/api/problems");
    return problemsCache;
  }

  // ------------------------------------------------------------------ theme
  function setThemeIcon() {
    const dark = document.documentElement.dataset.theme === "dark";
    $("#theme").innerHTML = icon(dark ? "sun" : "moon");
  }
  $("#theme").addEventListener("click", () => {
    const t = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
    document.documentElement.dataset.theme = t;
    store.set("theme", t);
    setThemeIcon();
    window.dispatchEvent(new Event("hwlc-theme"));
  });
  setThemeIcon();

  // ------------------------------------------------------------------ tools dialog
  async function loadTools() {
    const btn = $("#tools-btn");
    try {
      const t = await api("/api/tools");
      const tools = t.tools;
      const hasV = tools.iverilog.path || tools.verilator.path;
      const core = hasV && tools.yosys.path && tools.ghdl.path;
      btn.classList.add(core ? "ok" : (hasV || tools.ghdl.path) ? "partial" : "bad");
      $("#tools-label").textContent = core ? "Tools ready" : "Tools missing";
      $("#tools-body").innerHTML =
        Object.entries(tools).map(([n, i]) => `
          <div class="tool-row">${sico(i.path ? "pass" : "fail")}<b>${esc(n)}</b>
          <div><div>${esc(i.purpose)}</div><div class="v">${esc(i.version || "not installed")}</div></div></div>`).join("") +
        `<p class="muted" style="font-size:13px">Verilog/SV simulator: <b>${esc(t.sv_simulator || "none")}</b>. Start with
         <code>HWLC_SV_SIM=verilator</code> for fuller SystemVerilog support (slower compile).</p>
         <div class="install">Arch:   sudo pacman -S iverilog yosys verilator
        yay -S ghdl                  (AUR)
Debian: sudo apt install iverilog yosys verilator ghdl</div>`;
    } catch (e) {
      btn.classList.add("bad");
      $("#tools-label").textContent = "Server offline";
    }
  }
  $("#tools-btn").addEventListener("click", () => $("#tools-dialog").classList.remove("hidden"));
  $("#tools-dialog").addEventListener("click", e => {
    if (e.target.id === "tools-dialog" || e.target.closest("[data-close]")) $("#tools-dialog").classList.add("hidden");
  });

  // ------------------------------------------------------------------ drawer
  function openDrawer() {
    $("#drawer").classList.add("open");
    $("#drawer-backdrop").classList.remove("hidden");
    renderDrawer();
    setTimeout(() => $("#drawer-search").focus(), 50);
  }
  function closeDrawer() {
    $("#drawer").classList.remove("open");
    $("#drawer-backdrop").classList.add("hidden");
  }
  async function renderDrawer() {
    const list = await loadProblems(true);
    const q = $("#drawer-search").value.toLowerCase();
    const cur = currentSlug();
    $("#drawer-progress").textContent = `${list.filter(p => p.status === "solved").length}/${list.length} Solved`;
    $("#drawer-list").innerHTML = list.filter(p => !q || p.title.toLowerCase().includes(q)).map(p => `
      <li data-slug="${esc(p.slug)}" class="${p.slug === cur ? "current" : ""}">
        <span class="status-ico ${p.status}">${p.status === "solved" ? icon("tick") : p.status === "attempted" ? "•" : ""}</span>
        <span>${p.id}. ${esc(p.title)}</span>
        <span class="d-diff ${p.difficulty.toLowerCase()}">${p.difficulty === "Medium" ? "Med." : esc(p.difficulty)}</span>
      </li>`).join("");
  }
  $("#open-drawer").addEventListener("click", openDrawer);
  $("#drawer-backdrop").addEventListener("click", closeDrawer);
  $("#drawer-search").addEventListener("input", renderDrawer);
  $("#drawer-list").addEventListener("click", e => {
    const li = e.target.closest("li[data-slug]");
    if (li) { closeDrawer(); location.hash = "#/p/" + li.dataset.slug; }
  });

  // prev / next / shuffle
  function currentSlug() {
    const m = location.hash.match(/^#\/p\/([\w-]+)/);
    return m ? m[1] : null;
  }
  async function step(delta) {
    const list = await loadProblems();
    const i = list.findIndex(p => p.slug === currentSlug());
    const next = list[(i + delta + list.length) % list.length];
    if (next) location.hash = "#/p/" + next.slug;
  }
  $("#prev").addEventListener("click", () => step(-1));
  $("#next").addEventListener("click", () => step(1));
  $("#shuffle").addEventListener("click", async () => {
    const list = (await loadProblems()).filter(p => p.slug !== currentSlug());
    if (list.length) location.hash = "#/p/" + list[Math.floor(Math.random() * list.length)].slug;
  });

  // ------------------------------------------------------------------ router
  let page = null;
  function route() {
    if (page && page.destroy) page.destroy();
    closeDrawer();
    const slug = currentSlug();
    document.body.classList.toggle("list-mode", !slug);
    page = slug ? showWorkspace(slug) : showList();
  }
  window.addEventListener("hashchange", route);

  // ------------------------------------------------------------------ list page
  function showList() {
    const view = $("#view");
    view.innerHTML = "";
    view.appendChild($("#tpl-list").content.cloneNode(true));
    document.title = "Problems · HDL Judge";
    let all = [];
    const f = { q: "", cat: store.get("f-cat", ""), diff: store.get("f-diff", "") };
    $("#f-cat").value = f.cat;
    $("#f-diff").value = f.diff;

    function draw() {
      const rows = all.filter(p =>
        (!f.cat || p.category === f.cat) && (!f.diff || p.difficulty === f.diff) &&
        (!f.q || (p.title + " " + p.tags.join(" ")).toLowerCase().includes(f.q)));
      $("#plist").innerHTML =
        `<div class="prow head"><span>Status</span><span>Title</span><span>Category</span><span>Difficulty</span></div>` +
        (rows.map(p => `
        <div class="prow" data-slug="${esc(p.slug)}">
          <span class="status-ico ${p.status}" title="${p.status}">${p.status === "solved" ? icon("tick") : p.status === "attempted" ? "•" : ""}</span>
          <span><span class="ptitle">${p.id}. ${esc(p.title)}</span><br><span class="ptags">${p.tags.map(esc).join(" · ")} · ${p.languages.map(l => LANG_LABEL[l]).join(", ")}</span></span>
          <span class="cat-chip ${esc(p.category)}">${esc(catLabel(p.category))}</span>
          <span class="${p.difficulty.toLowerCase()}">${esc(p.difficulty)}</span>
        </div>`).join("") || `<div class="prow"><span></span><span class="muted">No problems match.</span></div>`);

      // progress ring per difficulty
      const solved = all.filter(p => p.status === "solved");
      const frac = all.length ? solved.length / all.length : 0;
      const C = 2 * Math.PI * 26;
      const by = d => `${solved.filter(p => p.difficulty === d).length}/${all.filter(p => p.difficulty === d).length}`;
      $("#progress-ring").innerHTML = `
        <svg class="ring" viewBox="0 0 64 64"><circle cx="32" cy="32" r="26" fill="none" stroke="var(--fill-2)" stroke-width="5"/>
          <circle cx="32" cy="32" r="26" fill="none" stroke="var(--green)" stroke-width="5" stroke-linecap="${frac ? "round" : "butt"}"
            stroke-dasharray="${C * frac} ${C}" transform="rotate(-90 32 32)"/>
          <text x="32" y="36" text-anchor="middle" font-size="14" font-weight="600" fill="var(--text)">${solved.length}/${all.length}</text></svg>
        <div class="ring-legend"><div class="easy">Easy ${by("Easy")}</div><div class="medium">Med. ${by("Medium")}</div><div class="hard">Hard ${by("Hard")}</div></div>`;
    }
    $("#plist").addEventListener("click", e => {
      const r = e.target.closest(".prow[data-slug]");
      if (r) location.hash = "#/p/" + r.dataset.slug;
    });
    $("#search").addEventListener("input", e => { f.q = e.target.value.toLowerCase(); draw(); });
    $("#f-cat").addEventListener("change", e => { f.cat = e.target.value; store.set("f-cat", f.cat); draw(); });
    $("#f-diff").addEventListener("change", e => { f.diff = e.target.value; store.set("f-diff", f.diff); draw(); });
    loadProblems(true).then(p => { all = p; draw(); })
      .catch(e => { $("#plist").innerHTML = `<div class="prow"><span></span><span>Could not load problems: ${esc(e.message)}</span></div>`; });
    return {};
  }

  // ------------------------------------------------------------------ workspace
  function showWorkspace(slug) {
    const view = $("#view");
    view.innerHTML = "";
    view.appendChild($("#tpl-workspace").content.cloneNode(true));
    const ws = $("#ws");
    const ctl = { destroyed: false, wave: null, cleanups: [] };
    const on = (target, ev, fn, opt) => { target.addEventListener(ev, fn, opt); ctl.cleanups.push(() => target.removeEventListener(ev, fn, opt)); };
    let problem = null, lang = null, editor = null, errMarks = [], busy = false, caseIdx = 0, lastResult = null;

    // ---------------------------------------------------------------- layout
    const DEFAULT_LEFT = 0.45, DEFAULT_CONSOLE = 0.38;
    function applyLayout() {
      const left = parseFloat(store.get("layout-left", DEFAULT_LEFT));
      const cons = parseFloat(store.get("layout-console", DEFAULT_CONSOLE));
      ws.style.setProperty("--left", (left * 100) + "%");
      ws.style.setProperty("--console", (cons * 100) + "%");
      ws.classList.toggle("console-collapsed", store.get("console-collapsed", "0") === "1");
      updateCollapseIcon();
    }
    function updateCollapseIcon() {
      const c = ws.classList.contains("console-collapsed");
      const b = $("#console-toggle");
      b.innerHTML = icon(c ? "up" : "down");
      b.title = c ? "Expand console" : "Collapse console";
    }
    function setCollapsed(c) {
      ws.classList.toggle("console-collapsed", c);
      store.set("console-collapsed", c ? "1" : "0");
      updateCollapseIcon();
      refreshEditor();
    }

    function dragGutter(gutter, axis) {
      gutter.addEventListener("pointerdown", e => {
        if (e.button !== 0) return;
        e.preventDefault();
        try { gutter.setPointerCapture(e.pointerId); } catch (err) { /* synthetic event */ }
        gutter.classList.add("dragging");
        document.body.classList.add("resizing", axis === "x" ? "col" : "row");
        if (axis === "y" && ws.classList.contains("console-collapsed")) setCollapsed(false);
        const move = ev => {
          if (axis === "x") {
            const r = ws.getBoundingClientRect();
            const inner = r.width - 20;
            let px = ev.clientX - r.left - 10;
            px = Math.max(260, Math.min(inner - 340, px));
            const frac = px / inner;
            ws.style.setProperty("--left", (frac * 100) + "%");
            store.set("layout-left", frac);
          } else {
            const r = $("#stack").getBoundingClientRect();
            let px = r.bottom - ev.clientY - 4;
            px = Math.max(40, Math.min(r.height - 130, px));
            const frac = px / r.height;
            ws.style.setProperty("--console", (frac * 100) + "%");
            store.set("layout-console", frac);
          }
          refreshEditor();
        };
        const up = () => {
          gutter.classList.remove("dragging");
          document.body.classList.remove("resizing", "col", "row");
          gutter.removeEventListener("pointermove", move);
          gutter.removeEventListener("pointerup", up);
          gutter.removeEventListener("pointercancel", up);
          window.dispatchEvent(new Event("resize"));
          refreshEditor();
        };
        gutter.addEventListener("pointermove", move);
        gutter.addEventListener("pointerup", up);
        gutter.addEventListener("pointercancel", up);
      });
      gutter.addEventListener("dblclick", () => {
        if (axis === "x") store.set("layout-left", DEFAULT_LEFT); else store.set("layout-console", DEFAULT_CONSOLE);
        applyLayout();
        refreshEditor();
      });
    }
    dragGutter($("#g-col"), "x");
    dragGutter($("#g-row"), "y");
    applyLayout();

    $$("[data-max]", ws).forEach(b => b.addEventListener("click", () => toggleMax(b.dataset.max)));
    function toggleMax(id) {
      const cls = "max-" + id;
      const wasMax = ws.classList.contains(cls);
      ws.classList.remove("max-panel-desc", "max-panel-code", "max-panel-console");
      if (!wasMax) ws.classList.add(cls);
      $$("[data-max]", ws).forEach(b => {
        const m = ws.classList.contains("max-" + b.dataset.max);
        b.innerHTML = icon(m ? "min" : "max");
        b.title = m ? "Restore" : "Maximize";
      });
      if (!wasMax && id === "panel-console") setCollapsed(false);
      refreshEditor();
      window.dispatchEvent(new Event("resize"));
    }
    $("#console-toggle").addEventListener("click", () => setCollapsed(!ws.classList.contains("console-collapsed")));

    // tabs
    function activate(group, name) {
      const panel = group === "left" ? $("#panel-desc") : $("#panel-console");
      $$(".ptab[data-tab]", panel).forEach(t => t.classList.toggle("active", t.dataset.tab === name));
      $$("[data-pane]", panel).forEach(p => p.classList.toggle("hidden", p.dataset.pane !== name));
      if (group === "console" && ws.classList.contains("console-collapsed")) setCollapsed(false);
      if (name === "wave") requestAnimationFrame(() => window.dispatchEvent(new Event("resize")));
    }
    $$(".ptabs[data-group]", ws).forEach(g => g.addEventListener("click", e => {
      const t = e.target.closest(".ptab[data-tab]");
      if (t) activate(g.dataset.group, t.dataset.tab);
    }));

    // ---------------------------------------------------------------- editor
    const ta = $("#code");
    const fontSize = () => parseFloat(store.get("font-size", "13.5"));
    function applyFont() { ws.style.setProperty("--code-size", fontSize() + "px"); refreshEditor(); }
    if (window.CodeMirror) {
      editor = CodeMirror.fromTextArea(ta, {
        lineNumbers: true, indentUnit: 4, tabSize: 4, indentWithTabs: false,
        matchBrackets: true, autoCloseBrackets: true, styleActiveLine: true,
        extraKeys: {
          "Ctrl-/": "toggleComment", "Cmd-/": "toggleComment",
          Tab: cm => cm.somethingSelected() ? cm.indentSelection("add") : cm.replaceSelection("    "),
          "Shift-Tab": cm => cm.indentSelection("subtract"),
        },
      });
      editor.on("change", () => saveDraft());
      const ro = new ResizeObserver(() => refreshEditor());
      ro.observe($(".editor-host"));
      ctl.cleanups.push(() => ro.disconnect());
    } else {
      on(ta, "keydown", e => {
        if (e.key === "Tab") { e.preventDefault(); ta.setRangeText("    ", ta.selectionStart, ta.selectionEnd, "end"); }
      });
      on(ta, "input", () => saveDraft());
    }
    function refreshEditor() { if (editor) editor.refresh(); }
    applyFont();
    $("#font-inc").addEventListener("click", () => { store.set("font-size", Math.min(22, fontSize() + 1)); applyFont(); });
    $("#font-dec").addEventListener("click", () => { store.set("font-size", Math.max(10, fontSize() - 1)); applyFont(); });

    const getCode = () => editor ? editor.getValue() : ta.value;
    const setCode = v => { if (editor) editor.setValue(v); else ta.value = v; };
    const draftKey = () => `draft:${slug}:${lang}`;
    let savedTimer = null;
    function saveDraft() {
      if (!lang) return;
      store.set(draftKey(), getCode());
      $("#saved").textContent = "Saved";
      clearTimeout(savedTimer);
      savedTimer = setTimeout(() => { $("#saved").textContent = ""; }, 1200);
    }
    function setLang(l) {
      lang = l;
      store.set("lang", l);
      $("#lang").value = l;
      setCode(store.get(draftKey(), null) ?? problem.starters[l]);
      if (editor) { editor.setOption("mode", CM_MODE[l]); editor.clearHistory(); }
      clearErrMarks();
      $("#saved").textContent = "";
    }
    function clearErrMarks() {
      if (editor) errMarks.forEach(h => editor.removeLineClass(h, "background", "cm-line-error"));
      errMarks = [];
    }
    $("#reset").addEventListener("click", () => {
      if (!problem || !confirm("Reset to the starter code? Your current code will be discarded.")) return;
      store.del(draftKey());
      setCode(problem.starters[lang]);
    });

    // global shortcuts
    on(document, "keydown", e => {
      const mod = e.ctrlKey || e.metaKey;
      if (mod && e.key === "Enter") { e.preventDefault(); judge("submit"); }
      else if (mod && e.key === "'") { e.preventDefault(); judge("run"); }
      else if (e.key === "Escape" && /max-panel/.test(ws.className)) {
        const m = ws.className.match(/max-(panel-\w+)/);
        if (m) toggleMax(m[1]);
      }
    });
    const runBtn = $("#run"), subBtn = $("#submit");
    const onRun = () => judge("run"), onSubmit = () => judge("submit");
    on(runBtn, "click", onRun);
    on(subBtn, "click", onSubmit);

    // ---------------------------------------------------------------- load problem
    api("/api/problems/" + slug).then(async p => {
      if (ctl.destroyed) return;
      problem = p;
      document.title = `${p.id}. ${p.title} · HDL Judge`;
      const sel = $("#lang");
      sel.innerHTML = p.languages.map(l => `<option value="${l}">${LANG_LABEL[l]}</option>`).join("");
      const pref = store.get("lang", p.languages[0]);
      setLang(p.languages.includes(pref) ? pref : p.languages[0]);
      sel.addEventListener("change", () => setLang(sel.value));
      const list = await loadProblems().catch(() => []);
      const me = list.find(x => x.slug === slug);
      renderDescription(p, me && me.status === "solved");
      renderCases();
      loadSubmissions();
    }).catch(e => { $(".desc").innerHTML = `<p>Could not load problem: ${esc(e.message)}</p>`; });

    // Timing diagram (problems/<slug>/waves.json) as inline SVG.
    function renderWaveSvg(w) {
      const T = w.length, RH = 26, H = 16, NAMEW = 12 + 7.2 * Math.max(...w.signals.map(s => s.name.length));
      const labels = w.signals.filter(s => s.kind === "bus").flatMap(s => s.values.map(String));
      const longest = Math.max(1, ...labels.map(l => l.length));
      let uw;
      if (w.unit === 0) uw = Math.max(34, 7.4 * longest + 12);
      else {
        // widen units until most bus segments can hold their label
        const segs = [];
        for (const s of w.signals.filter(s => s.kind === "bus")) {
          let k = 0;
          while (k < T) { let j = k; while (j + 1 < T && s.values[j + 1] === s.values[k]) j++; segs.push([j - k + 1, String(s.values[k]).length]); k = j + 1; }
        }
        const need = segs.map(([n, l]) => (7.4 * l + 8) / n).sort((a, b) => a - b);
        uw = Math.max(w.unit >= 8 ? 4 : 11, Math.min(60, need.length ? need[Math.floor(need.length * 0.8)] : 0));
      }
      const RM = w.signals.some(s => s.kind === "real") ? 44 : 8;     // right margin for real-valued scales
      const W = NAMEW + T * uw + RM, HT = w.signals.length * RH + 8;
      const X = t => NAMEW + t * uw;
      let g = "";
      if (w.unit > 0 && w.signals.some(s => s.kind === "clk"))      // grid at rising clock edges
        for (let t = 0; t < T; t++) {
          const c = w.signals.find(s => s.kind === "clk");
          const v = c.values ? c.values : null;
          const rising = v ? (t > 0 && v[t] === 1 && v[t - 1] === 0) : (w.unit === 2 && t % 2 === 1);
          if (rising) g += `<line x1="${X(t)}" y1="0" x2="${X(t)}" y2="${HT}" class="wv-grid"/>`;
        }
      if (w.unit === 0) for (let t = 1; t < T; t++) g += `<line x1="${X(t)}" y1="0" x2="${X(t)}" y2="${HT}" class="wv-grid"/>`;
      w.signals.forEach((s, r) => {
        const y0 = 6 + r * RH, yH = y0 + 2, yL = y0 + 2 + H, yM = y0 + 2 + H / 2;
        g += `<text x="4" y="${yM + 4}" class="wv-name">${esc(s.name)}</text>`;
        let vals = s.values;
        if (s.kind === "clk" && !vals) vals = Array.from({ length: T }, (_, t) => t % 2);
        if (s.kind === "clk" || s.kind === "bit") {
          let d = "", prev = null;
          for (let t = 0; t < T; t++) {
            const v = vals[t];
            if (v === "x" || v === null) {
              g += `<rect x="${X(t)}" y="${yH}" width="${uw}" height="${H}" class="wv-x"/>`; prev = null; continue;
            }
            const y = v ? yH : yL;
            if (prev === null) d += `M${X(t)},${y}`; else if (prev !== y) d += `L${X(t)},${prev}L${X(t)},${y}`;
            d += `L${X(t + 1)},${y}`; prev = y;
          }
          g += `<path d="${d}" class="${s.kind === "clk" ? "wv-clk" : "wv-bit"}"/>`;
        } else if (s.kind === "bus") {
          let k = 0;
          while (k < T) {
            let j = k; while (j + 1 < T && vals[j + 1] === vals[k]) j++;
            const a = X(k), b = X(j + 1), e = Math.min(3, (b - a) / 3), lab = String(vals[k]);
            const cls = lab === "x" ? "wv-busx" : "wv-bus";
            g += `<polygon points="${a},${yM} ${a + e},${yH} ${b - e},${yH} ${b},${yM} ${b - e},${yL} ${a + e},${yL}" class="${cls}"/>`;
            if (lab !== "x" && 7.4 * lab.length + 4 <= b - a)
              g += `<text x="${(a + b) / 2}" y="${yM + 4}" class="wv-label" text-anchor="middle">${esc(lab)}</text>`;
            else if (lab !== "x" && b - a >= 12)
              g += `<text x="${(a + b) / 2}" y="${yM + 4}" class="wv-label" text-anchor="middle">…</text>`;
            k = j + 1;
          }
        } else if (s.kind === "real") {
          const nums = vals.filter(v => typeof v === "number");
          const lo = Math.min(...nums), hi = Math.max(...nums), span = (hi - lo) || 1;
          let d = "";
          vals.forEach((v, t) => { if (typeof v === "number") { const y = yL - (v - lo) / span * H; d += `${d ? "L" : "M"}${X(t)},${y}L${X(t + 1)},${y}`; } });
          g += `<path d="${d}" class="wv-real"/>`;
          g += `<text x="${W - 4}" y="${yH + 7}" class="wv-scale" text-anchor="end">${+hi.toPrecision(3)}</text>`;
          g += `<text x="${W - 4}" y="${yL}" class="wv-scale" text-anchor="end">${+lo.toPrecision(3)}</text>`;
        }
      });
      return `<figure class="wave-fig">
          <figcaption class="wave-title">${esc(w.title || "")}</figcaption>
          <div class="wave-scroll"><svg width="${W}" height="${HT}" style="width:${W}px;height:${HT}px;max-width:none" viewBox="0 0 ${W} ${HT}" role="img" aria-label="${esc(w.title || "waveform")}">${g}</svg></div>
          ${w.caption ? `<div class="wave-cap">${renderInline(w.caption)}</div>` : ""}
        </figure>`;
    }

    function renderDescription(p, solved) {
      const note = {
        required: "<b>Must be synthesizable.</b> Your design is synthesized with Yosys/GHDL. Unsynthesizable constructs, inferred latches, undriven outputs or a wrong port list fail the submission.",
        optional: "<b>Behavioral model.</b> Synthesizability is not required: the synthesis result is shown for information only.",
        none: "<b>Behavioral model.</b> Synthesis is not checked for this problem.",
      }[p.synthesis];
      let kindNote = note;
      if (p.kind === "testbench")
        kindNote = "<b>Write a testbench.</b> It runs against the correct (hidden) design, where it must stay silent, and against several buggy versions, where it must report <code>$error</code>. You are graded on the bugs you catch.";
      else if (p.kind === "checker")
        kindNote = "<b>Write a checker.</b> Hidden signal traces are replayed into your assertions. They must fail on every violating trace and never on a legal one. Runs on Verilator.";
      else if (p.uvm)
        kindNote = "<b>UVM.</b> Your classes are compiled together with the UVM library (chipsalliance/uvm-verilator) and a hidden UVM test that grades them. The types under <i>Provided types</i> are compiled before your code. Building UVM with Verilator takes about a minute per run.";
      else if (p.kind === "component")
        kindNote = "<b>Verification component.</b> Write the SystemVerilog class described above. A hidden testbench drives it and checks what it reports. The types under <i>Provided types</i> are compiled before your code. Runs on Verilator.";
      else if (p.simulator === "verilator" && p.synthesis === "none")
        kindNote = "<b>Constraint randomization.</b> The hidden testbench calls <code>randomize()</code> hundreds of times and checks the rules and the randomness. Runs on Verilator with the z3 solver.";
      else if (p.max_logic_depth != null)
        kindNote = `<b>Timing budget: ${p.max_logic_depth} logic levels.</b> Your design must be correct and its critical path (reported in the Synthesis stage) must fit the budget.`;
      const examples = (p.examples || []).map((ex, i) => `
        <div class="example">
          <div class="ex-label">Example ${i + 1}: <span>${esc(ex.title)}</span></div>
          <div class="ex-block">
            <div><b>Stimulus:</b> ${esc(ex.input)}</div>
            <div><b>Expected:</b> ${esc(ex.expected)}</div>
          </div>
        </div>`).join("");
      const constraints = (p.constraints || []).length
        ? `<div class="sec-title">Constraints:</div><ul class="constraints">${p.constraints.map(c => `<li>${renderInline(c)}</li>`).join("")}</ul>` : "";
      const hints = (p.hints || []).map((h, i) => `
        <details class="acc hint">
          <summary>${icon("bulb")}Hint ${i + 1}${icon("down", "chev")}</summary>
          <div class="hint-body">${renderInline(h)}</div>
        </details>`).join("");
      $(".desc").innerHTML = `
        <h1 class="q-title">${p.id}. ${esc(p.title)}${solved ? `<span class="solved">Solved ${icon("tick")}</span>` : ""}</h1>
        <div class="q-chips">
          <span class="chip ${p.difficulty.toLowerCase()}">${esc(p.difficulty)}</span>
          <span class="chip">${esc(catLabel(p.category))}</span>
          <button class="chip" data-jump="topics">${icon("tag")}Topics</button>
          ${p.hints && p.hints.length ? `<button class="chip" data-jump="hint">${icon("bulb")}Hint</button>` : ""}
        </div>
        <div class="synth-note">${kindNote}</div>
        <div class="md">${renderMarkdown(p.description)}</div>
        ${examples ? `<div class="sec-title">Examples</div>${examples}` : ""}
        ${(p.waves && p.waves.length) ? `<div class="sec-title">Example waveforms</div>${p.waves.map(renderWaveSvg).join("")}` : ""}
        ${constraints}
        <p class="muted" style="font-size:13px;margin-top:18px">Top-level ${p.languages.includes("vhdl") ? "module / entity" : "module"}: <code>${esc(p.top)}</code></p>
        <div class="accordions">
          <details class="acc" id="acc-topics">
            <summary>${icon("tag")}Topics${icon("down", "chev")}</summary>
            <div class="acc-body">${p.tags.map(t => `<span class="chip">${esc(t)}</span>`).join("")}</div>
          </details>
          ${hints}
          <details class="acc">
            <summary>${icon("chip")}How it is judged${icon("down", "chev")}</summary>
            <div class="acc-body">1. <b>Compile</b> (Icarus Verilog / GHDL, Verilator lint)<br>
              2. <b>Synthesis</b> (Yosys${p.synthesis === "required" ? ", graded" : ", informational"})<br>
              3. <b>Hidden testbench</b>: <i>Run</i> grades the ${(p.examples || []).length} example cases, <i>Submit</i> grades every check, including randomized ones.</div>
          </details>
        </div>`;
      $$("[data-jump]", $(".desc")).forEach(b => b.addEventListener("click", () => {
        const target = b.dataset.jump === "topics" ? $("#acc-topics") : $(".acc.hint");
        if (!target) return;
        target.open = true;
        target.scrollIntoView({ behavior: "smooth", block: "center" });
        target.classList.remove("flash"); void target.offsetWidth; target.classList.add("flash");
      }));
    }

    // ---------------------------------------------------------------- Testcase tab
    function renderCases() {
      const ex = problem.examples || [];
      if (!ex.length) {
        $(".cases").innerHTML = '<div class="empty-state">This problem has no example cases. Submit to run the full testbench.</div>';
        return;
      }
      caseIdx = Math.min(caseIdx, ex.length - 1);
      const c = ex[caseIdx];
      $(".cases").innerHTML = `
        <div class="case-tabs">${ex.map((_, i) => `<button class="case-tab ${i === caseIdx ? "active" : ""}" data-case="${i}">Case ${i + 1}</button>`).join("")}</div>
        <div class="field-label">Check</div><div class="field">${esc(c.title)}</div>
        <div class="field-label">Stimulus</div><pre class="field">${esc(c.input)}</pre>
        <div class="field-label">Expected</div><pre class="field">${esc(c.expected)}</pre>
        <div class="console-note">Test cases are driven by a hidden testbench. <b>Run</b> grades these ${ex.length} cases; <b>Submit</b> grades every hidden check, including randomized tests.</div>`;
      $$(".case-tab", $(".cases")).forEach(b => b.addEventListener("click", () => { caseIdx = +b.dataset.case; renderCases(); }));
    }

    // ---------------------------------------------------------------- judge
    async function judge(mode) {
      if (busy || !problem) return;
      busy = true;
      runBtn.disabled = subBtn.disabled = true;
      const btn = mode === "submit" ? subBtn : runBtn;
      const label = btn.querySelector("span");
      const prevLabel = label.textContent;
      label.textContent = "Pending";
      clearErrMarks();
      activate("console", "result");
      $(".result").innerHTML = `<div class="empty-state"><span><span class="spinner"></span>${mode === "run" ? "Running example cases…" : "Judging: compile → synthesis → testbench…"}</span></div>`;
      try {
        const r = await api("/api/judge", { problem: slug, language: lang, code: getCode(), mode });
        if (ctl.destroyed) return;
        lastResult = r;
        renderResult(r);
        if (mode === "submit") {
          loadSubmissions();
          if (r.accepted) {
            loadProblems(true).then(() => renderDescription(problem, true)).catch(() => {});
          }
        }
      } catch (e) {
        if (!ctl.destroyed) $(".result").innerHTML = `<div class="verdict bad">Error</div><p>${esc(e.message)}</p>`;
      } finally {
        busy = false;
        runBtn.disabled = subBtn.disabled = false;
        label.textContent = prevLabel;
      }
    }

    function renderResult(r) {
      const ok = r.accepted || r.verdict === "Checks Passed";
      const sim = r.stages.find(s => s.key === "sim");
      const synth = r.stages.find(s => s.key === "synth");
      const tests = sim.details.tests || [];
      let meta = `${LANG_LABEL[r.language]} · ${r.seconds}s`;
      if (r.mode === "submit" && r.total) meta = `${r.passed} / ${r.total} checks passed · ` + meta;

      let html = `<div class="verdict-row"><span class="verdict ${ok ? "ok" : "bad"}">${esc(r.verdict)}</span><span class="verdict-meta">${esc(meta)}</span></div>`;
      html += '<div class="stages">' + r.stages.map(s => `
        <button class="stage-pill" data-stage="${s.key}" title="${esc(s.summary)} — click for the log">
          ${sico(s.status)}<span class="s-name">${esc(s.name)}</span><span class="s-sum">${esc(s.summary)}</span>
        </button>`).join("") + "</div>";

      const failed = r.stages.find(s => s.status === "fail" && s.key !== "sim") ||
                     (sim.status === "fail" && !tests.length ? sim : null);
      if (failed) {
        const lines = failed.log.split("\n").filter(l => /error|warning|latch|sorry|syntax|not driven|timed out|%/i.test(l) && !/^\$ /.test(l));
        html += `<pre class="error-box">${esc((lines.length ? lines.slice(0, 30) : [failed.summary]).join("\n"))}</pre>`;
      }

      if (r.mode === "run" && tests.length) {
        const ex = problem.examples || [];
        const k = Math.min(caseIdx, tests.length - 1);
        const t = tests[k];
        const e = ex[t.case ?? k] || {};
        html += `<div class="case-tabs">${tests.map((c, i) => `
          <button class="case-tab ${i === k ? "active" : ""}" data-rcase="${i}"><span class="dot ${c.pass ? "ok" : "bad"}"></span>Case ${i + 1}</button>`).join("")}</div>
          <div class="field-label">Check</div><div class="field">${esc(t.name)}</div>
          <div class="field-label">Stimulus</div><pre class="field">${esc(e.input || "")}</pre>
          <div class="field-label">Your design</div><pre class="field ${t.pass ? "ok" : "bad"}">${t.pass ? "✓ behaves as expected" : esc(t.detail || "check failed")}</pre>
          <div class="field-label">Expected</div><pre class="field">${esc(e.expected || "")}</pre>`;
      } else if (tests.length) {
        const firstFail = tests.find(t => !t.pass);
        if (firstFail) {
          html += `<div class="field-label">First failing check</div><pre class="field bad">${esc(firstFail.name)}${firstFail.detail ? "\n" + esc(firstFail.detail) : ""}</pre>`;
        }
        html += `<div class="field-label">All checks</div><ul class="check-list">${tests.map(t => `
          <li>${sico(t.pass ? "pass" : "fail")}<span>${esc(t.name)}${!t.pass && t.detail ? `<span class="c-detail">${esc(t.detail)}</span>` : ""}</span></li>`).join("")}</ul>`;
      }

      const st = synth.details.stats;
      const tm = synth.details.timing;
      if (st) {
        html += `<div class="field-label">Synthesis (Yosys generic gates)</div>
          <div class="stats">
            <div class="stat"><b>${st.cells}</b><span>cells</span></div>
            <div class="stat"><b>${st.flip_flops}</b><span>flip-flops</span></div>
            <div class="stat"><b>${st.latches}</b><span>latches</span></div>
            ${tm ? `<div class="stat ${tm.limit != null && tm.depth > tm.limit ? "over" : ""}"><b>${tm.depth}${tm.limit != null ? ` / ${tm.limit}` : ""}</b><span>logic depth</span></div>` : ""}
          </div>
          ${tm ? `<div class="cells">critical path: ${[tm.start].concat(tm.through, [tm.end]).map(esc).join(" → ")}</div>` : ""}
          <div class="cells">${Object.entries(st.by_type).sort((a, b) => b[1] - a[1]).map(([t, n]) => `${esc(t)}×${n}`).join("  ")}</div>`;
      }
      if (r.wave && r.wave.signals.length) html += `<p><button class="link-btn" id="to-wave">View waveform →</button></p>`;
      $(".result").innerHTML = html;

      $$("[data-rcase]", $(".result")).forEach(b => b.addEventListener("click", () => { caseIdx = +b.dataset.rcase; renderResult(lastResult); }));
      $$(".stage-pill", $(".result")).forEach(b => b.addEventListener("click", () => {
        activate("console", "logs");
        const d = $(`.logs details[data-stage="${b.dataset.stage}"]`);
        if (d) { d.open = true; d.scrollIntoView({ block: "nearest" }); }
      }));
      const tw = $("#to-wave");
      if (tw) tw.addEventListener("click", () => activate("console", "wave"));

      // logs
      $(".logs").innerHTML = r.stages.map(s => `
        <details data-stage="${s.key}" ${s.status === "fail" ? "open" : ""}>
          <summary>${sico(s.status)}<b>${esc(s.name)}</b><span class="muted">${esc(s.summary)}</span></summary>
          <pre>${esc(s.log || "(no output)")}</pre>
        </details>`).join("");

      // error lines in the editor
      if (editor) {
        const seen = new Set();
        r.stages.filter(s => s.status === "fail").forEach(s => {
          for (const m of s.log.matchAll(/design\.(?:sv|v|vhd):(\d+)/g)) {
            const ln = +m[1] - 1;
            if (!seen.has(ln) && ln >= 0 && ln < editor.lineCount()) {
              seen.add(ln);
              errMarks.push(editor.addLineClass(ln, "background", "cm-line-error"));
            }
          }
        });
      }

      // waveform
      if (ctl.wave) ctl.wave.destroy();
      ctl.wave = null;
      const wp = $(".wave-panel");
      if (r.wave && r.wave.signals.length) ctl.wave = new WaveViewer(wp, r.wave);
      else wp.innerHTML = '<div class="empty-state">No waveform: the testbench did not run.</div>';
    }
    on(window, "hwlc-theme", () => { if (ctl.wave) ctl.wave.draw(); });

    // ---------------------------------------------------------------- submissions
    async function loadSubmissions() {
      try {
        const subs = await api("/api/submissions/" + slug);
        if (ctl.destroyed) return;
        const tab = $('.ptab[data-tab="subs"]');
        tab.innerHTML = `${icon("clock", "c-blue")}Submissions${subs.length ? ` <span class="badge-n">${subs.length}</span>` : ""}`;
        if (!subs.length) { $(".subs").innerHTML = '<div class="empty-state">No submissions yet.</div>'; return; }
        $(".subs").innerHTML = `<table class="subs-table"><thead><tr><th>Status</th><th>Language</th><th>Checks</th><th>Cells</th><th>Submitted</th></tr></thead><tbody>` +
          subs.map((s, i) => `<tr class="row" data-i="${i}" title="Open this code in the editor">
            <td class="${s.verdict === "Accepted" ? "v-ok" : "v-bad"}">${esc(s.verdict)}</td>
            <td>${LANG_LABEL[s.language] || esc(s.language)}</td>
            <td>${s.total ? `${s.passed}/${s.total}` : "–"}</td>
            <td>${s.cells ?? "–"}</td>
            <td class="muted">${new Date(s.ts * 1000).toLocaleString()}</td></tr>`).join("") + "</tbody></table>";
        $(".subs").onclick = e => {
          const tr = e.target.closest("tr[data-i]");
          if (!tr) return;
          const s = subs[+tr.dataset.i];
          if (!confirm("Open this submission in the editor? Your current code will be replaced.")) return;
          if (s.language !== lang) setLang(s.language);
          setCode(s.code);
        };
      } catch (e) { /* history is optional */ }
    }

    ctl.destroy = () => {
      ctl.destroyed = true;
      ctl.cleanups.forEach(f => f());
      if (ctl.wave) ctl.wave.destroy();
    };
    return ctl;
  }

  loadTools();
  route();
})();
