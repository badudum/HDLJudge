The registers between pipeline stages do more than delay data. They must **stall** (hold
everything when a later stage is busy) and **flush** (turn younger instructions into
bubbles after a branch misprediction or exception).

Build a 3-stage pipeline of (valid, data) registers with those controls:

| Condition (priority order) | S1 | S2 | S3 |
|----------------------------|----|----|----|
| `rst`    | invalid | invalid | invalid |
| `flush`  | invalid (input dropped) | invalid | ← S2 |
| `stall`  | hold | hold | hold |
| normal   | ← input | ← S1 | ← S2 |

```
cycle   :  1   2   3   4   5   6   7
in      :  A   B   C   D   E   F   G
flush   :  0   0   0   1   0   0   0
out     :  -   -   -   A   B   -   -    then E, F, …
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `stall`, `flush` | input | 1 |
| `in_valid` | input | 1 |
| `in_data` | input | 16 |
| `out_valid` | output | 1 |
| `out_data` | output | 16 |
