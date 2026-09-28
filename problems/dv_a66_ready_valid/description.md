The two golden rules of every valid/ready interface (AXI and friends): a sender may not withdraw `valid`, and may not change `data`, until the receiver takes it.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `ready` | input | 1 |
| `data` | input | 8 |
