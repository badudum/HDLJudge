### How it works

Split the transaction into two steps, since Verilator can't chain two range delays in one sequence:

- `req |-> ##[1:3] gnt`
- `gnt |-> ##[1:5] done`

"No new request while a transaction is open" needs state: an `open` flag set by `req` and
cleared after `done`, then `req |-> !open`. Add `cover property` on each phase to see which cases
the stimulus exercised.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- The `done` cycle still counts as open, so a `req` in the same cycle as `done` is illegal.
