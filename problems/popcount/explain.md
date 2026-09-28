### How it works

Counting ones is adding 16 one-bit numbers. A chain of 15 adders works but is slow. An **adder tree** is faster:

```
16 × 1-bit → 8 × 2-bit sums → 4 × 3-bit → 2 × 4-bit → 1 × 5-bit
```

With carry-save (3:2) compressors, a Wallace tree, it gets even shallower. Popcount appears in Hamming distances,
bit-set sizes and neural-network accelerators (XNOR-popcount).

### Watch out for
- The result needs 5 bits (0 … 16).
- `$countones` is rejected by the judge.
