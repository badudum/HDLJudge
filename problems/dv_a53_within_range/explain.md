### How it works

A range check guarded by the qualifier: `valid |-> temp inside {[10:90]}`. When `valid` is low the
implication is vacuously true, which is what "don't-care" means for an assertion.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `inside {[10:90]}` includes both ends.
- Without `valid |->` the checker would fire on idle garbage.
