### How it works

`cnt ^ $past(cnt)` marks the bits that changed since the previous edge, and `$countones` of that
must be 0 or 1. `$past` returns the value sampled one clock earlier, and the property is checked
at every rising edge outside reset.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- At the first edge after reset, `$past(cnt)` is the value during reset. The traces start from 0, so that's safe here.
- Use `disable iff (rst)` so resetting the counter doesn't count as a jump.
