Every flop in a clock domain must leave reset in the same cycle, but the reset pin is asynchronous. The standard fix is **asynchronous assertion, synchronous deassertion**.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `arst_n` | input | 1 |
| `rst_n` | output | 1 |
