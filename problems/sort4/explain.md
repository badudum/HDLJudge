### How it works

A **compare-and-swap** (CAS) unit orders two values. The optimal 4-input network uses five of them
in three layers:

```
in0 ─┬───────┬───────────── out0
in1 ─┴─┬─────┼──┬───────── out1
in2 ─┬─┼─────┴──┴───────── out2
in3 ─┴─┴───────────────── out3
     (0,1)(2,3) (0,2)(1,3) (1,2)
```

Layer 1 sorts two pairs, layer 2 places the global min and max, and layer 3 fixes the middle.
Because the comparisons don't depend on the data, the network sorts every input, and the three
layers keep the critical path short.

### Watch out for
- Ties: `a < b` or `a <= b` both work, since equal values are interchangeable.
