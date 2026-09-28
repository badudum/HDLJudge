### How it works

"Has `a` ever been high earlier?" is history that a plain property can't express easily. Keep a sticky flag,
set one cycle after `a` is seen and cleared by reset, then assert `b |-> seen_a`.

```
always @(posedge clk) if (rst) seen_a <= 0; else if (a) seen_a <= 1;
```

Because the flag is registered, `a` and `b` in the same first cycle is correctly flagged.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- The flag must be cleared by reset, since the rule restarts after every reset.
