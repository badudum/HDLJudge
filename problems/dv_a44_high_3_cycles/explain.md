### How it works

`$rose(en) |-> en[*3]`: from the cycle it rose, en is high for 3 consecutive samples. The
consequent is a sequence of length 3, so the check completes two cycles later.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `en[*3]` counts the rising cycle itself.
