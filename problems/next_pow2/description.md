Round a 16-bit unsigned number **up to the next power of two**, e.g. when sizing buffers or hash tables
in hardware allocators:

| `x`   | `y`   |
|-------|-------|
| 0     | 1     |
| 1     | 1     |
| 5     | 8     |
| 64    | 64    |
| 65    | 128   |
| 40000 | 65536 |

The catch: **no loops and no helpers** such as `$clog2`, `$countones` or `**`. The judge
rejects them. There is a neat constant-depth trick using only shifts, ORs and one adder.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `x`  | input  | 16 |
| `y`  | output | 17 |
