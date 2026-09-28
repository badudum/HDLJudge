Your first **AXI4-Lite** slave. The protocol has five independent valid/ready channels: write
address (AW), write data (W), write response (B), read address (AR) and read data (R). The
testbench is a randomized master that varies channel order and delays and applies
backpressure, and it checks the protocol rules on every cycle.

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
| `reg_out` | output | 32 |
