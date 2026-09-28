Buses such as AHB and AXI require naturally aligned transfers, and the address must be held until the slave accepts it. Check both rules.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `ready` | input | 1 |
| `size` | input | 2 |
| `addr` | input | 8 |
