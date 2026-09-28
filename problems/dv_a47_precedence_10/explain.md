### How it works

Looking **backwards** 10 cycles is easiest with a small model: a counter reloaded to 10 by `start`
and counting down every cycle. `done` is legal while the counter is non-zero:

```
always @(posedge clk) if (rst) win <= 0; else if (start) win <= 10; else if (win) win <= win - 1;
a_done: assert property (@(posedge clk) disable iff (rst) done |-> win != 0);
```

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `start` and `done` in the same cycle doesn't count, and the registered counter handles that for free.
