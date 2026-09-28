### How it works

- `$onehot0(gnt)` and `(gnt & ~req) == 0`, checked every cycle.
- Fairness: for each master i, `gnt[i] |=> !(gnt[i] && (req & ~(1 << i)) != 0)`. If master i was
  granted, it may be granted again only if nobody else is requesting.

This is a *local* fairness property: it forbids back-to-back grants to one master while others
wait, which is round-robin behaviour.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Compare the **next** cycle's request vector, so use `|=>` and sample `req` in the consequent.
