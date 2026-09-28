A pipeline register computes `y <= a + b`. Write the assertion that checks every result
against the operands from the previous cycle. This is the typical form of a data-path checker.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `a` | input | 8 |
| `b` | input | 8 |
| `y` | input | 9 |
