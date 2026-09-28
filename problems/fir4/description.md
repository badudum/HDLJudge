A finite impulse response filter: a delay line and a weighted sum. The coefficients are small constants, so shifts and adds replace multipliers.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `din` | input | 8 |
| `dout` | output | 12 |
