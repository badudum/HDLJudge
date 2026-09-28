### How it works

The digit-by-digit (restoring) square root decides one result bit per cycle, from the most
significant down:

```
root = 0
for i = 7 … 0:
    cand = root | (1 << i)
    if cand² ≤ x:  root = cand
```

After 8 steps `root = ⌊√x⌋`. The multiplier can be avoided by keeping a running remainder (the
non-restoring algorithm), which is what dividers and square-root units in FPUs do.

### Watch out for
- Clear `root` at start, since it's built up bit by bit.
- `done` must be high for exactly one cycle, exactly 8 edges after `start`.
