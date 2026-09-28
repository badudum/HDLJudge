### How it works

A sequence describes several consecutive samples: `din ##1 din ##1 !din ##1 din` matches 1, 1, 0,
1 on four consecutive edges. Use it as the antecedent of a next-cycle implication:

```
(din ##1 din ##1 !din ##1 din) |=> lock
```

The implication is checked when the sequence **ends**, so `lock` is required on the cycle after
the last 1.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Overlapping patterns (1 1 0 1 1 0 1) start several attempts in parallel. SVA handles that automatically.
