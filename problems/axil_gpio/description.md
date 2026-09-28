A general-purpose I/O block behind an AXI4-Lite interface, like Xilinx AXI GPIO. It has output, direction and input registers, plus an atomic toggle register so software can flip bits without a read-modify-write.

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
| `gpio_in` | input | 8 |
| `gpio_out` | output | 8 |
| `gpio_oe` | output | 8 |
