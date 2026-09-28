### How it works

After a change, q is stable for exactly 3 cycles and changes on the 4th:

```
q != $past(q) |=> $stable(q) [*3] ##1 (q != $past(q))
```

This describes a divide-by-8 clock (4 cycles high, 4 low).

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- The first change after reset starts the pattern, and before that q may stay constant.
