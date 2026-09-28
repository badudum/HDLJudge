### How it works

Bounded liveness: `$rose(req[i]) |-> ##[0:4] gnt[i]` for each master. `##[0:4]` means "within 0 to 4
cycles, counting the current one". Unbounded liveness ("eventually") can't be checked in finite
simulation, so real protocols specify a bound.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Instantiate the property per master (generate loop).
- Verilator doesn't support a chain of two range delays in one sequence, but a single `##[0:4]` is fine.
