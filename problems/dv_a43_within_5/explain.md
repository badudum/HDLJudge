### How it works

A bounded response: `req |-> ##[1:5] ack`. The obligation is evaluated as the cycles go by. It
passes at the first `ack` within the window and fails if 5 cycles pass without one.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `##[1:5]` starts one cycle **after** the request, so an ack in the same cycle doesn't count.
