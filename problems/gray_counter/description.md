Asynchronous FIFOs pass their read/write pointers between clock domains as **Gray codes**,
because only one bit changes per increment. A synchronizer then sees either the old or the new
value, never a mixture.

Build a 5-bit Gray-code counter with enable:

| count | bin | gray |
|-------|-----|------|
| 0 | 00000 | 00000 |
| 1 | 00001 | 00001 |
| 2 | 00010 | 00011 |
| 3 | 00011 | 00010 |
| 4 | 00100 | 00110 |
| … | | |
| 31 | 11111 | 10000 |

The Gray output must come **straight from flip-flops**. The judge's synthesis stats will show if
it is combinational.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `en` | input | 1 |
| `gray`, `bin` | output | 5 |
