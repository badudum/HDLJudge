Square roots show up in graphics, DSP and distance calculations. Compute the integer square root one bit per clock using the digit-by-digit method.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `start` | input | 1 |
| `x` | input | 16 |
| `busy` | output | 1 |
| `done` | output | 1 |
| `root` | output | 8 |
