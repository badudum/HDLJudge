This is the 8-entry synchronous FIFO from problem 5, as implemented by a colleague. Integration
tests fail intermittently: occasionally a byte is **lost**, bytes are **duplicated** after a
burst, and the producer throttles one entry too early.

**3 bugs** are hidden in the starter code. Run it, read the failing checks, and fix them.

| Output | Meaning |
|--------|---------|
| `count` | number of stored entries, 0 – 8 |
| `empty` | `count == 0` |
| `full`  | `count == 8` |

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `wr_en`, `rd_en` | input | 1 |
| `din` | input | 8 |
| `dout` | output | 8 |
| `full`, `empty` | output | 1 |
| `count` | output | 4 |
