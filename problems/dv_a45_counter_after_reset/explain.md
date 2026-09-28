### How it works

- Reset value: `$fell(rst) |-> count == 0` checks the first cycle after reset is released. This
  one must not use `disable iff (rst)`.
- Behaviour: `!en |=> count == $past(count)` and `en |=> count == $past(count) + 4'd1`, both
  disabled during reset.

Checking *transitions* (next value from current value) is the standard way to specify a counter.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- The +1 must wrap in 4 bits: compare as 4-bit values.
