In **write-a-testbench** problems, the design is given and hidden. You write the
**self-checking testbench**. It is graded by *mutation testing*:

1. It runs against the **correct** design and must report nothing (no false alarms).
2. It runs against several **buggy variants**, each with one subtle bug, and must report an
   error for every one of them.

The design under test is the 4-bit counter from problem 2:

- on each rising edge of `clk`: `rst = 1` clears `count` (synchronous, has priority);
  otherwise `en = 1` increments it, wrapping 15 → 0; otherwise it holds.

```systemverilog
module tb;
    logic clk = 0, rst, en;
    logic [3:0] count;
    counter dut (.clk(clk), .rst(rst), .en(en), .count(count));
    // drive stimulus, predict, compare, $error(...) on mismatch, $finish
endmodule
```

Results show which bugs you caught; each bug's description appears once your testbench detects it.
Signals of `dut` are shown in the waveform.
