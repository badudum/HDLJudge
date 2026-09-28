A **moving-average filter** is the simplest low-pass FIR filter: every output is the mean
of the last N input samples. Here N = 4, so the division is a free shift.

```
valid_in : 1   1   1   1   1   0   1
din      : 100 100 100 100 100 7   0
dout     : 25  50  75  100 100 100 75
```

(Each column shows `dout` right after the rising edge that sampled that column's inputs.)

- A rising edge with `valid_in = 1` shifts `din` into the 4-sample window and updates `dout`
  with the new average, rounded down.
- With `valid_in = 0` nothing changes.
- `rst` (synchronous) fills the window with zeros and clears `dout`.

### Interface

| Port       | Direction | Width |
|------------|-----------|-------|
| `clk`      | input  | 1 |
| `rst`      | input  | 1 |
| `valid_in` | input  | 1 |
| `din`      | input  | 8 (unsigned) |
| `dout`     | output | 8 |
