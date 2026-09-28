Booth's algorithm multiplies two's-complement numbers directly by recoding runs of ones in the multiplier into one subtraction and one addition. Build the sequential radix-2 version.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `start` | input | 1 |
| `a` | input | 8 |
| `b` | input | 8 |
| `busy` | output | 1 |
| `done` | output | 1 |
| `p` | output | 16 |
