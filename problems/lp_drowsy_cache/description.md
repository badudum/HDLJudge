Leakage dominates cache power in modern nodes. **Drowsy caches** drop idle lines to a retention
voltage: data is kept, but the line needs a one-cycle wake-up before it can be accessed.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `we` | input | 1 |
| `idx` | input | 3 |
| `wdata` | input | 8 |
| `ready` | output | 1 |
| `rdata` | output | 8 |
| `drowsy` | output | 8 |
| `wakeups` | output | 8 |
