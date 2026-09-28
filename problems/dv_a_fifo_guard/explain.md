### How it works

Both rules are same-cycle implications:

- `push && full |-> pop`: a push into a full FIFO is only acceptable when a pop frees a slot in the same cycle.
- `pop |-> !empty`.

These guard assertions usually live in the FIFO's interface (or are bound to every instance) and
catch the most common integration bugs.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Don't forbid `push && full` outright: the simultaneous push + pop case is legal.
