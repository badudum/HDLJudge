**Way prediction** reads only one way of a set-associative cache at first, the one predicted by the MRU bit. It reads the others only on a mispredict, which saves most of the tag and data array energy.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `addr` | input | 6 |
| `pred` | output | 1 |
| `fast_hit` | output | 1 |
| `slow_hit` | output | 1 |
| `miss` | output | 1 |
| `tag_reads` | output | 16 |
