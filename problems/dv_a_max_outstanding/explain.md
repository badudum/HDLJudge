### How it works

Assertions describe *relationships*, but "how many are in flight" needs counting. So model it:
`cnt <= cnt + req − rsp`, then assert on the model: a new request needs `cnt < 2`, and a response
needs `cnt > 0`. Formal tools and simulators treat such auxiliary code exactly like the design.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- A request and a response in the same cycle leave the count unchanged, so that's legal even at the limit.
