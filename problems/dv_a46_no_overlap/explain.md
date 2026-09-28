### How it works

- `!(gnt_a && gnt_b)` every cycle.
- Handover gap: `$fell(gnt_a) |-> !gnt_b` and `$fell(gnt_b) |-> !gnt_a`. The cycle in which one
  grant drops must not already carry the other, which leaves one idle cycle between owners.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `$fell` is true in the first cycle the signal is low.
