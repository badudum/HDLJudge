The simplest clock divider: a toggle flip-flop halves the frequency. Keep the output straight off a flop, because clocks must never pass through combinational logic that could glitch.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `clk_out` | output | 1 |
