**Least-frequently-used** replacement evicts the entry with the fewest hits. Plain LFU never
forgets, so an entry that was hot long ago stays forever. Real designs **age** the counters.

Implement LFU bookkeeping for one 4-entry set:

- Every entry has a 3-bit use counter. `victim` is the entry with the lowest count
  (lowest index on ties).
- **fill** (a miss brings in a new line): the victim is replaced, and its counter restarts at 1.
- **hit** on `way`: that counter increments (saturating at 7).
- **Aging:** when an increment brings any counter to 7, all four counters are halved in the
  same cycle.

```
counts after reset:      0 0 0 0      victim 0
fill:                    1 0 0 0      victim 1
hit way 0 ×2:            3 0 0 0      victim 1
fill ×3:                 3 1 1 1      victim 1
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `hit`, `fill` | input | 1 |
| `way` | input | 2 |
| `victim` | output | 2 |
| `counts` | output | 12 (entry i at `[3i+2:3i]`) |
