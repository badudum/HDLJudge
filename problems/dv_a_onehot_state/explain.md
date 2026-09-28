### How it works

`$onehot(state)` is true when exactly one bit is 1 (`$onehot0` also accepts all zeros). A one-hot
FSM with a corrupted state (0 or two bits) is stuck, or behaves as two states at once, so this
invariant is a cheap and effective check.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Disable during reset: the register may be all-zero while reset is asserted.
