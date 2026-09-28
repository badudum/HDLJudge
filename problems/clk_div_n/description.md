A parameterized clock divider: one design, any ratio from 2 to 16. Odd ratios can't have an exact 50 % duty cycle with rising-edge flops only, so the spec rounds the high time down.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `clk_out` | output | 1 |
