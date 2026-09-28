// Tiny Markdown renderer for problem statements: headings, paragraphs, lists,
// fenced code, tables, inline code, bold/italic and links. Input is escaped first.
(function () {
  function esc(s) {
    return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }

  function inline(s) {
    const codes = [];
    s = esc(s).replace(/`([^`]+)`/g, (_, c) => { codes.push(c); return "\u0000" + (codes.length - 1) + "\u0000"; });
    s = s.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
         .replace(/(^|[^*])\*([^*\s][^*]*)\*/g, "$1<em>$2</em>")
         .replace(/\[([^\]]+)\]\((https?:[^)\s]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>');
    return s.replace(/\u0000(\d+)\u0000/g, (_, i) => "<code>" + codes[+i] + "</code>");
  }

  function splitRow(line) {
    return line.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map(c => c.trim());
  }

  function render(md) {
    const lines = md.replace(/\r/g, "").split("\n");
    const out = [];
    let i = 0;
    while (i < lines.length) {
      const line = lines[i];
      if (/^```/.test(line)) {
        const buf = [];
        i++;
        while (i < lines.length && !/^```/.test(lines[i])) buf.push(lines[i++]);
        i++;
        out.push("<pre><code>" + esc(buf.join("\n")) + "</code></pre>");
        continue;
      }
      let m = line.match(/^(#{1,4})\s+(.*)$/);
      if (m) {
        const lvl = Math.min(m[1].length + 1, 4);
        out.push(`<h${lvl}>${inline(m[2])}</h${lvl}>`);
        i++;
        continue;
      }
      if (/^\s*\|/.test(line) && i + 1 < lines.length && /^\s*\|?\s*:?-{2,}/.test(lines[i + 1])) {
        const head = splitRow(line);
        i += 2;
        const rows = [];
        while (i < lines.length && /^\s*\|/.test(lines[i])) rows.push(splitRow(lines[i++]));
        out.push("<table><thead><tr>" + head.map(h => "<th>" + inline(h) + "</th>").join("") +
                 "</tr></thead><tbody>" +
                 rows.map(r => "<tr>" + r.map(c => "<td>" + inline(c) + "</td>").join("") + "</tr>").join("") +
                 "</tbody></table>");
        continue;
      }
      if (/^\s*([-*]|\d+\.)\s+/.test(line)) {
        const ordered = /^\s*\d+\./.test(line);
        const items = [];
        while (i < lines.length && /^\s*([-*]|\d+\.)\s+/.test(lines[i])) {
          let item = lines[i++].replace(/^\s*([-*]|\d+\.)\s+/, "");
          while (i < lines.length && /^\s{2,}\S/.test(lines[i]) && !/^\s*([-*]|\d+\.)\s+/.test(lines[i]))
            item += " " + lines[i++].trim();
          items.push("<li>" + inline(item) + "</li>");
        }
        out.push((ordered ? "<ol>" : "<ul>") + items.join("") + (ordered ? "</ol>" : "</ul>"));
        continue;
      }
      if (!line.trim()) { i++; continue; }
      const para = [];
      while (i < lines.length && lines[i].trim() && !/^(```|#{1,4}\s|\s*\||\s*([-*]|\d+\.)\s+)/.test(lines[i]))
        para.push(lines[i++]);
      if (!para.length) para.push(lines[i++]);
      out.push("<p>" + inline(para.join(" ")) + "</p>");
    }
    return out.join("\n");
  }

  window.renderMarkdown = render;
  window.renderInline = inline;
})();
