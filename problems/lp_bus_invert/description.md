Off-chip buses burn power charging wire capacitance on every transition. **Bus-invert coding**
(Stan & Burleson, 1995) adds one wire. When more than half the bits would flip, it sends the
inverted word instead, so at most N/2 data wires toggle per transfer.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `din` | input | 8 |
| `bus_q` | output | 8 |
| `inv` | output | 1 |
| `dout` | output | 8 |
| `toggles` | output | 16 |
