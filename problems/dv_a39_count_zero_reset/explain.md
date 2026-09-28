### How it works

`rst |=> count == 0`. One edge after reset is sampled high, the counter must read zero. This is
the one kind of property you must **not** disable during reset (`disable iff (rst)` would switch
it off exactly when it matters).

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- An equivalent formulation is `$past(rst) |-> count == 0`.
