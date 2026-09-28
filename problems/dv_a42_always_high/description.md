A power-good indication from a regulator must never drop once it is asserted, at least not
without a reset. Write an assertion that catches any glitch or drop-out after `pwr_good`
first becomes high.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `pwr_good` | input | 1 |
