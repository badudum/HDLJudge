### How it works

- Parity: `valid |-> parity == ^data`. `^data` is the reduction XOR, which is 1 when data has an odd number of ones.
- `last |-> valid`.
- Packet length needs **state**: count valid beats since the last `last` in auxiliary code, and assert that
  an 8th beat has `last` set.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Reset the auxiliary beat counter on every beat with `last`, and on reset.
