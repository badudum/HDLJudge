Write the testbench for a small synchronous FIFO, graded by mutation testing against 8 buggy variants. A reference model plus boundary-focused stimulus is the winning strategy.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `wr_en` | input | 1 |
| `rd_en` | input | 1 |
| `din` | input | 8 |
| `dout` | output | 8 |
| `full` | output | 1 |
| `empty` | output | 1 |
| `count` | output | 3 |
