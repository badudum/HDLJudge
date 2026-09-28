### How it works

"Once high, stays high" is a next-cycle implication: `pwr_good |=> pwr_good`. It holds trivially
before the signal first rises, and after that it forbids any drop, so it expresses the whole rule.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Disable with reset: a reset legitimately restarts the sequence.
