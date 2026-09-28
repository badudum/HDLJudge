A real protocol checker: the AXI4-Lite **write** channels (AW address, W data, B response). Each channel follows the valid/ready rules, and a write response may only come after both the address and the data were accepted.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `awvalid` | input | 1 |
| `awready` | input | 1 |
| `wvalid` | input | 1 |
| `wready` | input | 1 |
| `bvalid` | input | 1 |
| `bready` | input | 1 |
