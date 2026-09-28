Dynamic frequency scaling means changing a divider's ratio while its clock is in use. If the ratio changes mid-period, the downstream logic sees one truncated pulse, and that is a glitch. Apply new ratios only at period boundaries.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `div` | input | 2 |
| `clk_out` | output | 1 |
