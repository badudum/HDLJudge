Clock gating at the finest useful grain: every byte of every register has its own enable. The `cg_en` output exposes the 16 enables so that the gating can be verified.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `we` | input | 1 |
| `waddr` | input | 2 |
| `wbe` | input | 4 |
| `wdata` | input | 32 |
| `raddr` | input | 2 |
| `rdata` | output | 32 |
| `cg_en` | output | 16 |
