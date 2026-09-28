A GPIO block as seen by a CPU: output and direction registers, a synchronized input register, and sticky edge-detect flags that software clears by writing 1s.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `we` | input | 1 |
| `addr` | input | 2 |
| `wdata` | input | 8 |
| `rdata` | output | 8 |
| `gpio_in` | input | 8 |
| `gpio_out` | output | 8 |
| `gpio_oe` | output | 8 |
