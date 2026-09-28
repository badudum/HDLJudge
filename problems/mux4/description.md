Design a purely combinational **8-bit wide 4-to-1 multiplexer**.

The output `y` must follow the input selected by `sel`:

| `sel` | `y` |
|-------|-----|
| 0     | `a` |
| 1     | `b` |
| 2     | `c` |
| 3     | `d` |

### Interface

| Port  | Direction | Width |
|-------|-----------|-------|
| `a`, `b`, `c`, `d` | input | 8 |
| `sel` | input | 2 |
| `y`   | output | 8 |
