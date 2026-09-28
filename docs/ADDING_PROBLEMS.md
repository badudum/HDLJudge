# Adding a problem

Each problem is one folder under `problems/`. The folder name is the problem's slug (used in URLs
and on the command line).

```
problems/my_problem/
├── problem.json             metadata
├── description.md           statement shown to the user (Markdown)
├── starter/
│   ├── verilog.v
│   ├── systemverilog.sv
│   └── vhdl.vhd
├── tb/
│   ├── tb.sv                hidden testbench for Verilog AND SystemVerilog submissions
│   └── tb.vhd               hidden testbench for VHDL submissions
└── solutions/               reference solutions, only used by `hwlc selftest`
    ├── verilog.v
    ├── systemverilog.sv
    └── vhdl.vhd
```

Only the languages listed in `problem.json` need files.

## problem.json

```json
{
  "id": 9,
  "title": "Gray Code Counter",
  "difficulty": "Medium",
  "category": "digital",
  "tags": ["sequential"],
  "top": "gray_counter",
  "synthesis": "required",
  "languages": ["verilog", "systemverilog", "vhdl"],
  "timeout_s": 20,
  "ports": [
    {"name": "clk",  "dir": "input",  "width": 1},
    {"name": "rst",  "dir": "input",  "width": 1},
    {"name": "gray", "dir": "output", "width": 4}
  ]
}
```

| Field | Meaning |
|-------|---------|
| `id` | sort order / number shown in the list |
| `difficulty` | `Easy`, `Medium` or `Hard` |
| `category` | `digital` or `modeling` (only affects labels and filters) |
| `top` | name of the module / entity the user must write |
| `synthesis` | `required` — must synthesize, grades latches/undriven outputs/ports; `optional` — synthesis runs and is shown but never fails the submission (use for `real`-valued models); `none` — skip synthesis |
| `allow_latches` | optional, `true` to accept inferred latches |
| `languages` | any of `verilog`, `systemverilog`, `vhdl` |
| `ports` | expected interface; checked against the synthesized netlist (names are case-insensitive). Add `"type": "real"` for documentation of real ports |
| `synth_params` | parameter / generic values used for synthesis and the interface check (should match the testbench's `PARAMS`), e.g. `{"WIDTH": 16}` |
| `max_logic_depth` | timing budget: longest combinational path in generic gates (timing problems) |
| `max_flip_flops` | limit on storage elements (`0` = purely combinational) |
| `forbidden` | list of `{"pattern", "message", "languages"?}` regexes rejected in the source (comments are ignored) |
| `kind` | `design` (default), `testbench` (mutation-graded, needs `dv/golden.v`, `dv/mutants/*`, `dv/mutants.json`) or `checker` (trace-replay, needs `traces`) |
| `simulator` | `verilator` to force Verilator (SVA, constraint randomization) |
| `timeout_s` | wall-clock limit for the simulation (default 20) |
| `examples` | visible example cases: `{"check", "title", "input", "expected"}`. `check` is the **prefix of a testbench check name**; *Run* grades only these checks |
| `constraints` | list of strings (inline Markdown), shown under "Constraints" |
| `hints` | list of strings (inline Markdown), shown as collapsible "Hint 1", "Hint 2", … |

## Testbench protocol

The testbench's top level must be called **`tb`** and instantiate the design as **`dut`** (or
`dut1`, `dut2`, … when testing several parameterizations). Only signals inside `tb.dut*` appear in
the user's waveform, so the testbench's own variables stay hidden.

The judge reads the simulator output:

- a line containing `PASS: <name>` is a passed check,
- a line containing `FAIL: <name> -- <details>` is a failed check (the details are shown to the user,
  so include the time and expected vs. actual values of the first mismatch),
- a line containing `TB_DONE` must be printed at the end — without it the run is a *Runtime Error*
  (or *Time Limit Exceeded* if it was killed).

Group many comparisons into a few named checks (e.g. "counts up and wraps", "300 random cycles"),
as the existing testbenches do with `start_test` / `end_test`.

### Verilog / SystemVerilog (`tb.sv`)

- Compiled with `iverilog -g2012` **and** must also work with Verilator (`--binary --timing`),
  so stay in the common subset: no classes, no `wire real` (use `real` variables), plain arrays
  instead of queues.
- Dump the waveform when `+vcd` is given:

  ```systemverilog
  $timeformat(-9, 0, " ns", 0);
  if ($test$plusargs("vcd")) begin
      $dumpfile("wave.vcd");
      $dumpvars(1, dut);
  end
  ```
- End with `$display("TB_DONE"); $finish;` and add a watchdog `initial` block for sequential designs.
- Drive inputs and compare outputs on the **falling** clock edge to avoid races with the design.

### VHDL (`tb.vhd`)

- Analyzed with `ghdl --std=08`; the judge adds `--vcd=wave.vcd`.
- Use `report "PASS: ..."` / `report "FAIL: ..."`, then `report "TB_DONE"; std.env.finish;`.
- Stop the clock generator when done (`clk <= not clk after 5 ns when not done;`).

## Checklist

1. Write the statement, starters and testbenches.
2. Write a reference solution per language in `solutions/`.
3. `python3 -m hwlc selftest my_problem` — every language must be **Accepted**.
4. `HWLC_SV_SIM=verilator python3 -m hwlc selftest my_problem` — the SV testbench must pass on Verilator too.
5. Submit a few wrong solutions (async instead of sync reset, off-by-one, missing default) and make
   sure the FAIL messages explain the bug.

## Generated testbenches (`gen.py`)

Most problems don't hand-write testbenches. They describe a reference model in `gen.py`, and
`python3 -m hwlc gen <slug>` writes `tb/vectors.txt`, `tb/tb.sv`, `tb/tb.vhd` and any missing starters.
See the docstring of `hwlc/vectors.py` for the timing model. Look at `problems/lfsr/gen.py` (clocked)
or `problems/popcount/gen.py` (combinational) for short examples.

Example labels (`examples[].check`) must be prefixes of check names; `hwlc gen` refuses to build otherwise.

### Checker (assertion) problems

Set `"kind": "checker", "simulator": "verilator", "synthesis": "none"` and list the checker's inputs as
ports. `gen.py` defines traces instead of vectors:

```python
CLOCK = "clk"
TRACES = [
    # (name, is_violation, {signal: per-cycle values})
    ("legal: ack after 2 cycles", 0, {"rst": "110", "req": "0001000", "ack": "0000010"}),
    ("violation: no ack",         1, {"rst": "110", "req": "0001000", "ack": "0000000"}),
]
```

Strings are per-cycle bit values, lists are integers, and shorter signals hold their last value.
Keep activity after reset, and remember that the testbench runs 3 idle cycles after each trace.
Pending obligations (e.g. "within 5 cycles") must not become due in that window on legal traces.

### Debug problems

Use `"category": "debug"`. Put the **buggy** design in `starter/`, the fixed one in `solutions/`,
and say in the statement how many bugs there are. `selftest` checks that the fixed design passes
**and** that the buggy starter fails. It checks the same for the empty starters of checker and
testbench problems.

### Hand-written testbenches (clocking, CDC, bus protocols)

Problems that need several clocks, sub-cycle timing, or a reactive bus master (clock dividers, ICG,
reset synchronizers, async FIFOs, AXI4-Lite slaves) have no `gen.py`: write `tb/tb.sv` directly and
restrict `"languages"` to `["verilog", "systemverilog"]`. Tips that bit us:

- Declare signals before the DUT instance, and print times with `%.1f` and `$realtime` (`%0t` prints in
  the simulation precision, i.e. picoseconds).
- Variables declared **with an initializer inside a loop** of an `initial` block are static and are
  initialized once. Put the stimulus in a `task automatic` and call it from `initial`.
- Don't rely on an edge at time 0 (`always @(posedge go)` with `go = 1` at time 0 is missed by Verilator).
- Zero-delay simulation can't show metastability, so enforce synchronizer latency explicitly (e.g. data may
  not cross in fewer than 2 destination-clock edges); otherwise an unsynchronized design passes.
- Run the problem with `HWLC_SV_SIM=verilator` as well as with Icarus.

### UVM and verification-component problems

Set `"simulator": "verilator", "synthesis": "none", "languages": ["systemverilog"]` and either
`"uvm": true` (UVM library compiled in; see the README) or `"kind": "component"` (plain SystemVerilog
classes, compiles in seconds). Files:

- `tb/prelude.sv`: types the solution builds on (interfaces, transaction classes, provided agents). It is
  compiled **before** the user's file; show it in the statement too.
- `tb/tb.sv`: the hidden harness. For UVM, a `uvm_test` whose `report_phase` prints the `PASS:` / `FAIL:`
  lines and `TB_DONE` (UVM calls `$finish` itself afterwards). Add a watchdog in `run_phase`, so that a
  driver that never returns a response yields a clear FAIL instead of a timeout.
- `"coverage": true` adds `--coverage-user`, without which Verilator ignores `cover property`.

The generated authoring scripts for the existing problems live outside the repository. Copy the
structure of `problems/dv_uvm_driver_response` for UVM and `problems/dv_ooo_scoreboard` for components.

### Explanations and example waveforms

- `explain.md` (optional) is inserted into the statement just before the Interface table. Use it for
  background, a worked example and a "Watch out for" list. Authoring scripts may regenerate
  `description.md` freely; `explain.md` is never touched by tools.
- `waves.json` holds example waveforms. For `gen.py` problems, `hwlc gen` / `hwlc waves` pick the checks
  named by the examples (12 clock cycles, or 8 combinational cases, continuing across checks). Override with

  ```python
  WAVES = [{"check": "counts up", "skip": 0, "n": 12, "title": "…", "signals": ["clk", "en", "count"]}]
  ```

- Hand-written testbench problems add `"wave_windows"` to `problem.json`; `hwlc waves <slug>` then
  simulates the reference solution and samples the DUT ports (`dut*` instances) from the VCD:

  ```json
  "wave_windows": [{"from": 0, "to": 200, "step": 5, "unit": 2, "clock": "clk",
                    "signals": ["clk", "dut1.vin:vin"], "title": "…", "caption": "…"}]
  ```

  `step` is the sampling interval in ns, `unit` the number of samples per clock period (for the grid),
  and `name:label` renames a signal. For multi-clock environments whose DUT is not directly under `tb`,
  write a small demo testbench and store its result in `waves.json` directly.
