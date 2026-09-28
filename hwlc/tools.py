"""Discovery of the external EDA tools the judge drives.

Every tool can be overridden with an environment variable, e.g.
HWLC_IVERILOG=/opt/iverilog/bin/iverilog.
"""
import os
import shutil
import subprocess

TOOLS = {
    "iverilog": "Icarus Verilog compiler (Verilog/SV compile + simulation)",
    "vvp": "Icarus Verilog runtime",
    "verilator": "Verilator (SV lint, optional SV simulator)",
    "yosys": "Yosys (synthesis check)",
    "ghdl": "GHDL (VHDL compile, simulation and synthesis)",
    "z3": "Z3 solver (SystemVerilog constraint randomization in Verilator)",
    "ccache": "compiler cache (optional: ~2.5x faster rebuilds of UVM problems)",
}

VERSION_ARGS = {
    "iverilog": ["-V"],
    "vvp": ["-V"],
    "verilator": ["--version"],
    "yosys": ["-V"],
    "ghdl": ["--version"],
    "z3": ["--version"],
    "ccache": ["--version"],
}


def find(name):
    override = os.environ.get("HWLC_" + name.upper())
    if override:
        return shutil.which(override)
    return shutil.which(name)


def version(name):
    path = find(name)
    if not path:
        return None
    try:
        out = subprocess.run([path] + VERSION_ARGS[name], capture_output=True,
                             text=True, timeout=10)
        text = (out.stdout or out.stderr).strip().splitlines()
        return text[0] if text else "unknown version"
    except (OSError, subprocess.TimeoutExpired):
        return "unknown version"


def status():
    return {name: {"path": find(name), "version": version(name), "purpose": purpose}
            for name, purpose in TOOLS.items()}


def sv_simulator():
    """Simulator used for Verilog/SystemVerilog submissions (HWLC_SV_SIM picks)."""
    pref = os.environ.get("HWLC_SV_SIM", "iverilog")
    order = [pref] + [s for s in ("iverilog", "verilator") if s != pref]
    for sim in order:
        if sim == "iverilog" and find("iverilog") and find("vvp"):
            return "iverilog"
        if sim == "verilator" and find("verilator"):
            return "verilator"
    return None


def uvm_home():
    """Directory of a Verilator-compatible UVM library (HWLC_UVM_HOME or third_party/uvm-verilator)."""
    from pathlib import Path
    cand = os.environ.get("HWLC_UVM_HOME") or str(Path(__file__).resolve().parent.parent / "third_party" / "uvm-verilator")
    return cand if os.path.exists(os.path.join(cand, "src", "uvm_pkg.sv")) else None
