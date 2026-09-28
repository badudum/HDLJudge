### How it works

- Flag consistency (same cycle): `full == (count == 8)` and `empty == (count == 0)`.
- Count bookkeeping (next cycle): define `acc_push = push && !full` and `acc_pop = pop && !empty`,
  then `acc_push && !acc_pop |=> count == $past(count) + 1`, the opposite for pops, and `count` holds otherwise.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Evaluate `full` / `empty` for the accepted handshakes at the **same** edge as `push` / `pop`, not after the update.
