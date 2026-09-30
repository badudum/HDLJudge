# HDL Judge (hwlc)

A local, LeetCode-style practice environment for hardware design in **Verilog**, **SystemVerilog**
and **VHDL**. Pick a problem, write the module in the browser, and the judge will:

1. **Compile** it (Icarus Verilog / GHDL, plus Verilator lint warnings for digital problems; SystemVerilog
   that Icarus can't parse automatically falls back to Verilator)
2. **Check synthesizability** with Yosys (VHDL goes through `ghdl --synth` first):
   non-synthesizable code, **inferred latches**, **undriven outputs**, multiple drivers / logic loops
   and a **wrong port list** fail the submission, and you get a cell / flip-flop count.
   For analog / behavioral *modeling* problems synthesis is reported but not graded.
   Every synthesized design also gets a **critical-path report** (logic depth and the path through
   your signals); timing problems grade it against a depth budget.
3. **Simulate** it against a **hidden testbench** and report each check as pass / fail, with the
   first mismatch (time, expected vs. actual value).
4. Show a **waveform** of your design's ports and internal signals (real-valued signals are drawn
   as analog traces).

Everything runs locally with open-source tools; the app itself is plain Python (standard library
only) plus a static web page.

## Prerequisites

| Tool | Needed for | Required? |
|------|-----------|-----------|
| **Python ≥ 3.9** | the judge, CLI and local web server (standard library only) | yes |
| **Icarus Verilog** (`iverilog`, `vvp`) ≥ 11 | compiling and simulating Verilog / SystemVerilog | yes |
| **Yosys** ≥ 0.30 | synthesis checks, cell counts, critical-path reports | yes |
| **Verilator** ≥ 5.028 | SystemVerilog fallback, assertion (SVA), constraint, class-based and UVM problems | recommended |
| **Z3** (`z3`) | constraint-randomization problems (Verilator's solver) | for those problems |
| **GHDL** (with `--synth`) | VHDL: compile, simulate, synthesize | for VHDL |
| **ccache** | faster re-runs of UVM problems | optional |
| **PyGObject + WebKitGTK** (6.0 or 4.1) | the desktop window; without it the app opens in your browser | optional |

The UVM library for UVM problems ships with the repository (`third_party/uvm-verilator`), so there's
nothing to install for UVM beyond Verilator.

**Arch Linux**

```sh
sudo pacman -S python iverilog yosys verilator z3 ccache python-gobject webkitgtk-6.0
yay -S ghdl                  # AUR (ghdl-mcode / ghdl-llvm also work)
```

**Debian / Ubuntu**

```sh
sudo apt install python3 iverilog yosys verilator z3 ghdl ccache python3-gi gir1.2-webkit-6.0
```

**Fedora**

```sh
sudo dnf install python3 iverilog yosys verilator z3 ghdl ccache python3-gobject webkitgtk6.0
```

**macOS** (Homebrew; the app opens in your browser)

```sh
brew install python icarus-verilog yosys verilator z3 ccache
```

Distribution packages are often old, and Verilator in particular must be ≥ 5.028 for the SVA / UVM
problems. The [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) provides current
builds of Icarus Verilog, Yosys, Verilator and GHDL for Linux, macOS and Windows in one download:
unpack it and `source <dir>/environment` before starting the judge. Tools can also be pointed to
individually with `HWLC_IVERILOG`, `HWLC_YOSYS`, `HWLC_VERILATOR`, `HWLC_GHDL`, … (see *Tools used*).

`python3 -m hwlc doctor` lists which tools were found and what each one is used for. A problem whose
tools are missing reports a clear error instead of a verdict.

## Quick start

```sh
git clone https://github.com/badudum/HDLJudge.git
cd HDLJudge
python3 -m hwlc doctor             # check the tool setup
./hwlc.sh                          # open the desktop app (same as: python3 -m hwlc gui)
python3 -m hwlc install-desktop    # optional: add "HDL Judge" to your application menu
```

The app opens in its own window (GTK + WebKitGTK through PyGObject). Without WebKitGTK it falls back
to your browser; `python3 -m hwlc serve` always uses the browser.

Your progress (submission history, solved problems, in-progress drafts) is stored locally in `data/`,
plus a fast local copy of drafts in the app's browser storage for zero-latency typing. None of it is
tracked by git.

## The workspace

The layout follows LeetCode:

- **Left:** the problem — statement, interface, **examples**, **constraints**, and collapsible **hints**
  and topics. A *Submissions* tab lists your history; click one to reopen its code.
- **Right, top:** the code editor (language picker, font size, reset to starter). Drafts are saved per
  problem and language.
- **Right, bottom:** the console — **Testcase** (the example cases), **Test Result**, **Waveform**, **Logs**.
- **Run** (`Ctrl+'`) grades only the example cases. **Submit** (`Ctrl+Enter`) grades every hidden check,
  including randomized tests, and records the submission.
- **Resizing:** drag the divider between the left and right panels, or between the editor and the
  console. Double-click a divider to reset it. Each panel has a maximize button (`Esc` restores), and
  the console can be collapsed. Sizes are remembered.
- Previous / next / random problem buttons and a slide-in problem list sit in the top bar, with a
  light / dark theme toggle.

## Command line

```sh
python3 -m hwlc list                              # problems and solved status
python3 -m hwlc show counter --starter vhdl       # statement + starter code
python3 -m hwlc submit counter my_counter.sv      # judge a file (language from extension)
python3 -m hwlc submit counter my_counter.v --check   # compile + synthesis only
python3 -m hwlc submit counter x.vhd -v --keep    # full logs, keep the work directory
python3 -m hwlc selftest                          # judge every reference solution
```

## Tools used

| Stage | Verilog / SystemVerilog | VHDL |
|-------|-------------------------|------|
| Compile | `iverilog -g2005` / `-g2012` (+ `verilator --lint-only -Wall` warnings) | `ghdl -a` / `ghdl -e` (VHDL-2008) |
| Synthesis | `yosys` (`synth`, `check -assert`, latch + port + undriven checks) | `ghdl --synth --out=verilog` → same Yosys flow |
| Simulation | `iverilog` + `vvp` (default) or Verilator | `ghdl --elab-run` |

Environment variables:

| Variable | Effect |
|----------|--------|
| `HWLC_UVM_HOME=/path/to/uvm-verilator` | UVM library for UVM problems (default: `third_party/uvm-verilator`) |
| `HWLC_SV_SIM=verilator` | simulate Verilog/SV with Verilator (better SystemVerilog support, ~6 s compile) instead of Icarus |
| `HWLC_IVERILOG`, `HWLC_VVP`, `HWLC_YOSYS`, `HWLC_GHDL`, `HWLC_VERILATOR` | use a specific tool binary |

## Problems

271 problems (49 easy, 127 medium, 95 hard). Each has examples, constraints, hints and a hidden testbench,
and most statements include explanations and example waveforms.
Every reference solution passes, in every language offered, in `python3 -m hwlc selftest`.

| Category | Count | What you do |
|----------|-------|-------------|
| Digital design | 91 | RTL: counters, FSMs, FIFOs (sync, async, width converters), skid buffers, RAMs, caches, UART / SPI, CRC, FIR, arbiters (incl. weighted RR), credit flow control, APB / AXI4-Lite slaves, clock dividers, reset synchronizers, CDC handshakes, brain teasers (bit tricks without loops, branchless arithmetic, NAND-only netlists, minimal-state FSMs) |
| Computer architecture | 34 | ALUs, Booth multiplier, branch predictor, return-address stack, TLB, integer square root, interrupt controller, decoders, hazard / forwarding units, register renaming, ROB, MSHR, LRU / PLRU / LFU, GPU warp scheduling |
| Analog / modeling | 9 | `real`-valued behavioral models: ADC, DAC, RC filter, sigma-delta, VCO, slew limiter |
| Verification | 91 | SVA checkers, constraint randomization, UVM components, scoreboards / monitors / drivers, testbenches graded by mutation testing |
| Low power | 17 | clock gating (ICG, FSM-driven, byte-level), isolation, retention, power sequencing, glitch-free clock muxes / dividers, drowsy caches, bus-invert coding |
| Debug | 15 | fix the bugs in a working-looking design (the starter code is the buggy version) |
| DFT | 8 | scan chains, MISR, LBIST pattern generator, boundary scan, JTAG TAP controller, March C- memory BIST against injected memory faults |
| Timing | 6 | meet a logic-depth budget: parity trees, comparator trees, priority-encoder trees, parallel-prefix adders, pipelining |

Clocking and CDC problems (clock dividers, ICG, reset synchronizer, async FIFO, handshakes, clock mux) and
the AXI4-Lite slaves have hand-written, protocol-aware testbenches (Verilog / SystemVerilog only): they
measure clock waveforms, drive unrelated clocks, enforce synchronizer latency, and check the AXI handshake
rules with a randomized master.

`python3 -m hwlc roadmap` shows coverage of the topic lists in [docs/ROADMAP.md](docs/ROADMAP.md)
(generated from `docs/roadmap.json`).

### Statements and example waveforms

A statement is `description.md` plus an optional `explain.md` (a longer "How it works / Watch out for"
section kept separate so regenerating a problem never overwrites it). Example waveforms live in
`waves.json` and are drawn as timing diagrams under the statement (SVG in the app, ASCII in `hwlc show`).
They are generated, not drawn by hand:

- `python3 -m hwlc gen` writes them from the reference model in `gen.py` (the stimulus of the examples),
  or from the legal / violating traces of checker problems;
- `python3 -m hwlc waves` regenerates them, including problems with hand-written testbenches, which
  list `wave_windows` in `problem.json` and are cut from a simulation of the reference solution.

### Problem kinds

- **design** (default): write the module; it is compiled, synthesized and simulated.
- **checker**: write assertions (SVA runs on Verilator); hidden traces are replayed into your checker,
  which must fire on every violating trace and stay silent on legal ones.
- **testbench**: write a self-checking testbench; it must pass the hidden correct design and report
  `$error` for each hidden buggy variant (mutation testing).
- **constraint** problems are design-kind problems on Verilator: a class with `rand` variables and
  constraints, randomized hundreds of times by the hidden testbench (needs `z3`).
- **component**: write a verification class (scoreboard, monitor, driver) in plain SystemVerilog; a hidden
  testbench drives it on Verilator and checks what it reports.
- **UVM** (`"uvm": true`): write UVM components (driver, monitor, scoreboard, subscriber, env, RAL model,
  SVA-to-UVM reporting); they are compiled with the UVM library and a hidden UVM test (see below).

### Adding problems

A problem is a folder under `problems/`. Most testbenches are **generated** from a Python reference
model: write `gen.py` and run `python3 -m hwlc gen <slug>` to produce the vector file, the
SystemVerilog and VHDL testbenches, and starter code. Checker problems describe their traces in
`gen.py` too. See [docs/ADDING_PROBLEMS.md](docs/ADDING_PROBLEMS.md).

### UVM problems

UVM problems run on **Verilator** with [chipsalliance/uvm-verilator](https://github.com/chipsalliance/uvm-verilator)
(UVM 2017-1.0 patched for Verilator, Apache-2.0), vendored in `third_party/uvm-verilator`. Nothing needs
to be installed beyond Verilator ≥ 5.028; set `HWLC_UVM_HOME` to use another copy of the library.

- Every run compiles the UVM library (about 20 MB of C++), which takes **about a minute** on 16 cores.
  Installing `ccache` (`sudo pacman -S ccache`) makes re-running *unchanged* code much faster; the judge
  uses it automatically.
- Built with `+define+UVM_NO_DPI`: no `uvm_hdl_*` backdoor and no command-line plusargs. Use `run_test("…")`.
- Verilator's `covergroup` support is still incomplete, so coverage problems use manual bins; `cover property`
  works (the judge adds `--coverage-user` for problems with `"coverage": true`).

To add one: set `"uvm": true, "simulator": "verilator", "synthesis": "none", "languages": ["systemverilog"]`,
put the types the solution builds on in `tb/prelude.sv` (compiled before the user's file) and a hidden UVM
test in `tb/tb.sv` that prints `PASS: …` / `FAIL: name -- detail` lines and `TB_DONE` from its
`report_phase`. The authoring pattern is in [docs/ADDING_PROBLEMS.md](docs/ADDING_PROBLEMS.md).

## Verdicts

| Verdict | Meaning |
|---------|---------|
| Accepted | compiled, (synthesized), and every testbench check passed |
| Compile Error | the design, or the design together with the testbench, does not compile — usually a syntax error or a wrong module/port name |
| Synthesis Error | synthesis required and failed: unsynthesizable code, latch, undriven output, logic loop / multiple drivers, port mismatch, or flip-flops in a combinational-only problem |
| Timing Violation | functionally correct, but the critical path exceeds the problem's logic-depth budget |
| Rule Violation | the code uses a construct the problem forbids (e.g. `$countones`, loops, `/`) |
| Wrong Answer | at least one testbench check failed |
| Time Limit Exceeded | the simulation ran past the problem's time limit (e.g. a zero-delay loop) |
| Runtime Error | the simulation stopped before the testbench finished |

## Notes and limits

- Icarus Verilog implements a subset of SystemVerilog (no classes / interfaces, strict enum casting). If it
  rejects a SystemVerilog submission, the judge retries with Verilator automatically. Yosys also parses only a
  subset of SystemVerilog; unsupported constructs are reported as a parse problem, not as "not synthesizable".
- Logic depth is measured in generic 2-input gates before technology mapping. It tracks the structure you
  wrote (ripple vs. prefix adder, chain vs. tree), not the delay of a particular FPGA or standard-cell library.
- GHDL does not write enumerated-type signals (e.g. FSM state types) to VCD, so they are missing from the
  VHDL waveform. Integer / `std_logic(_vector)` / `real` signals are shown.
- Submissions run your code with local tools under a timeout and file-size limit, but **not in a
  sandbox**. The server only listens on `127.0.0.1` and rejects cross-site requests; don't expose it
  on a network you don't trust.
