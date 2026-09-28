### How it works

A lock arbiter guarantees mutual exclusion and doesn't take a lock away from its owner. Three
properties:

1. `$onehot0(lock_gnt)`: never two owners at once.
2. For each master i: `$rose(lock_gnt[i]) |-> lock_req[i]`. A **new** grant only goes to a requester.
3. For each i: `lock_gnt[i] && lock_req[i] |=> lock_gnt[i]`. No revocation while the owner still wants the lock.

Use a `generate for` loop (or three copies) for the per-master rules.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Rule 2 is about **rising** grants: a master that releases its request keeps the grant for one more cycle while the arbiter reacts, and that's legal.
- `|->` checks the same cycle and `|=>` the next one.
