Write a small set of assertions for a 4-bit up-counter with enable: it must start at 0 after
reset, hold when disabled, and increment by exactly one when enabled.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `en` | input | 1 |
| `count` | input | 4 |
