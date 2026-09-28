The performance team reports that the branch predictor is barely better than a coin flip, and that
loops which should be predicted perfectly suddenly mispredict after a few iterations.

**2 bugs** are hidden in the code.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `pc` | input | 8 |
| `update` | input | 1 |
| `upd_pc` | input | 8 |
| `taken` | input | 1 |
| `pred` | output | 1 |
| `ctr` | output | 2 |
