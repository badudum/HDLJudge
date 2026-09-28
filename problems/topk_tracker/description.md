Streaming top-K: keep the K = 3 largest values of an unbounded stream in hardware, using one comparison layer per sample. It shows up in network telemetry and in search accelerators.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `din` | input | 8 |
| `t0` | output | 8 |
| `t1` | output | 8 |
| `t2` | output | 8 |
