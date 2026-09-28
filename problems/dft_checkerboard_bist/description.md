A memory BIST engine that writes a checkerboard pattern, reads it back, then repeats with the inverse. It's fast (4N operations) and sensitive to coupling between neighbouring cells.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `start` | input | 1 |
| `mem_rdata` | input | 8 |
| `mem_addr` | output | 4 |
| `mem_we` | output | 1 |
| `mem_wdata` | output | 8 |
| `busy` | output | 1 |
| `done` | output | 1 |
| `fail` | output | 1 |
