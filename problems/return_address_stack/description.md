Return instructions jump to many different places, so ordinary branch target buffers predict them badly. A small **return address stack** mirrors the call stack in hardware and predicts almost every return.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `push` | input | 1 |
| `pop` | input | 1 |
| `addr` | input | 8 |
| `top` | output | 8 |
| `count` | output | 3 |
