### How it works

Describe the legal **transitions** as next-state implications, one per state:

```
state == IDLE |=> state inside {IDLE, REQ}
state == XFER |=> state == DONE          // also forbids staying in XFER
```

Add a `cover property` for each legal arc, so coverage shows which transitions the tests
actually exercised. That's FSM arc coverage.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Transitions out of reset aren't constrained: disable during reset.
