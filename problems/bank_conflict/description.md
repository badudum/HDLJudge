GPU shared memory is split into **banks** that work in parallel. A warp's accesses finish in
one cycle only if no two lanes need *different* words from the *same* bank. Otherwise the
accesses to that bank are serialized, a **bank conflict**.

For a 4-lane access to a 4-bank memory (bank = address mod 4):

```
addresses  0  1  2  3   -> banks 0 1 2 3            1 cycle
addresses  0  4  8 12   -> banks 0 0 0 0, 4 words   4 cycles (4-way conflict)
addresses  8  8  8  8   -> bank 0, one word          1 cycle  (broadcast)
addresses  0  4  0  5   -> bank 0: {0,4}, bank 1: {5} 2 cycles
```

Report how many cycles the access needs (the worst bank's number of distinct words) and whether
there is a conflict.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `addr` | input | 32 (four 8-bit lane addresses, lane i at `[8i+7:8i]`) |
| `valid` | input | 4 |
| `conflict` | output | 1 |
| `cycles` | output | 3 |
