The most common memory in FPGA designs: a **single-port** synchronous RAM with a registered read
in **read-first** mode. A read in the same cycle as a write to the same address returns the
**old** contents.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `en` | input | 1 |
| `we` | input | 1 |
| `addr` | input | 6 |
| `wdata` | input | 8 |
| `rdata` | output | 8 |
