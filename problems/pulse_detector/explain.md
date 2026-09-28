### How it works

Keep the last three samples in a shift register and match the pattern 0, 1, 0 (oldest first). Wider pulses
(0 1 1 0) don't match, because the middle sample must be the only 1:

```
din   0 0 1 0 0 1 1 0
hist  … 010 …   … 110 …
pulse       1           (only for the single-cycle pulse)
```

### Watch out for
- `pulse` is registered: it appears one cycle after the final 0 was sampled.
