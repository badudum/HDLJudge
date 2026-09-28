### How it works

`valid && !ready |=> $stable(data)`. The antecedent is sampled at one edge and the consequent at
the next. `$stable(data)` means "same value as at the previous edge".

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- After the handshake cycle (`valid && ready`), data may change freely.
