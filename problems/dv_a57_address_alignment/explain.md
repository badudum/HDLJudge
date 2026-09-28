### How it works

Two kinds of rule:

- **Legality** (same cycle): with `valid`, size 3 is illegal, a halfword needs `addr[0] == 0`, and a word needs `addr[1:0] == 0`.
- **Stability** (next cycle): `valid && !ready |=> $stable(addr) && $stable(size)`. It's the
  standard valid/ready rule that the payload is frozen while stalled.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Put each rule in its own assertion so a failure message tells you which rule broke.
