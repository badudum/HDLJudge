"""Loading of problem definitions from the problems/ directory.

Layout of one problem (see docs/ADDING_PROBLEMS.md):

    problems/<slug>/
        problem.json        metadata (title, top module, ports, synthesis mode, ...)
        description.md      statement shown to the user
        starter/<lang>.<ext>    starter code per language
        tb/tb.sv            hidden testbench for Verilog + SystemVerilog
        tb/tb.vhd           hidden testbench for VHDL
        solutions/<lang>.<ext>  reference solutions (used by `hwlc selftest`)
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PROBLEMS_DIR = ROOT / "problems"

LANGUAGES = {
    "verilog": {"label": "Verilog", "ext": ".v", "family": "verilog"},
    "systemverilog": {"label": "SystemVerilog", "ext": ".sv", "family": "verilog"},
    "vhdl": {"label": "VHDL", "ext": ".vhd", "family": "vhdl"},
}

# required: the design must synthesize (digital problems)
# optional: synthesis is attempted and reported, but never fails the submission
# none:     synthesis is not attempted (pure behavioral / analog modeling)
SYNTHESIS_MODES = ("required", "optional", "none")


class Problem:
    def __init__(self, path):
        self.path = Path(path)
        meta = json.loads((self.path / "problem.json").read_text())
        self.meta = meta
        self.slug = self.path.name
        self.id = meta["id"]
        self.title = meta["title"]
        self.difficulty = meta.get("difficulty", "Easy")
        self.category = meta.get("category", "digital")
        self.tags = meta.get("tags", [])
        self.top = meta["top"]
        self.ports = meta.get("ports", [])
        self.synthesis = meta.get("synthesis", "required")
        if self.synthesis not in SYNTHESIS_MODES:
            raise ValueError(f"{self.slug}: bad synthesis mode {self.synthesis!r}")
        self.timeout = meta.get("timeout_s", 20)
        self.languages = [l for l in meta.get("languages", list(LANGUAGES))
                          if l in LANGUAGES]
        self.constraints = meta.get("constraints", [])
        self.hints = meta.get("hints", [])
        # visible example cases; "check" is the prefix of a testbench check name
        self.examples = meta.get("examples", [])

    def _lang_file(self, folder, lang):
        return self.path / folder / (lang + LANGUAGES[lang]["ext"])

    def starter(self, lang):
        f = self._lang_file("starter", lang)
        return f.read_text() if f.exists() else ""

    def solution_file(self, lang):
        f = self._lang_file("solutions", lang)
        return f if f.exists() else None

    def testbench(self, lang):
        name = "tb.vhd" if LANGUAGES[lang]["family"] == "vhdl" else "tb.sv"
        f = self.path / "tb" / name
        return f if f.exists() else None

    def description(self):
        f = self.path / "description.md"
        text = f.read_text() if f.exists() else ""
        extra = self.path / "explain.md"          # longer explanation, kept apart from generated statements
        if extra.exists():
            more = extra.read_text().strip() + "\n\n"
            cut = text.find("### Interface")
            text = text[:cut] + more + text[cut:] if cut >= 0 else text.rstrip() + "\n\n" + more
        return text

    def waves(self):
        f = self.path / "waves.json"
        return json.loads(f.read_text()) if f.exists() else []

    def summary(self):
        return {
            "id": self.id, "slug": self.slug, "title": self.title,
            "difficulty": self.difficulty, "category": self.category,
            "tags": self.tags, "synthesis": self.synthesis,
            "languages": self.languages,
            "kind": self.meta.get("kind", "design"),
            "simulator": self.meta.get("simulator"),
            "uvm": bool(self.meta.get("uvm")),
            "max_logic_depth": self.meta.get("max_logic_depth"),
        }

    def detail(self):
        d = self.summary()
        d.update({
            "top": self.top, "ports": self.ports,
            "description": self.description(),
            "starters": {l: self.starter(l) for l in self.languages},
            "constraints": self.constraints, "hints": self.hints,
            "examples": self.examples,
            "waves": self.waves(),
        })
        return d


def load_all():
    problems = []
    if PROBLEMS_DIR.exists():
        for p in sorted(PROBLEMS_DIR.iterdir()):
            if (p / "problem.json").exists():
                problems.append(Problem(p))
    problems.sort(key=lambda p: p.id)
    return problems


def get(slug):
    for p in load_all():
        if p.slug == slug:
            return p
    return None
