A control block that software only writes: a configuration register, and a "command" register whose bits fire one-cycle strobes (start, clear, kick…) into the hardware.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `aclk` | input | 1 |
| `aresetn` | input | 1 |
| `awaddr` | input | 8 |
| `awvalid` | input | 1 |
| `awready` | output | 1 |
| `wdata` | input | 32 |
| `wstrb` | input | 4 |
| `wvalid` | input | 1 |
| `wready` | output | 1 |
| `bresp` | output | 2 |
| `bvalid` | output | 1 |
| `bready` | input | 1 |
| `araddr` | input | 8 |
| `arvalid` | input | 1 |
| `arready` | output | 1 |
| `rdata` | output | 32 |
| `rresp` | output | 2 |
| `rvalid` | output | 1 |
| `rready` | input | 1 |
| `ctrl_out` | output | 32 |
| `pulse_out` | output | 8 |
