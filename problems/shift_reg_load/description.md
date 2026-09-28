The universal shift register: load a byte in parallel, shift it out serially in either direction,
or shift a serial stream in. It is the heart of SPI/UART serializers, CRC generators and scan
chains.

| rst | load | shift | dir | next `q` |
|-----|------|-------|-----|----------|
| 1 | – | – | – | 0 |
| 0 | 1 | – | – | `din` |
| 0 | 0 | 1 | 0 | `{q[6:0], serial_in}` (left) |
| 0 | 0 | 1 | 1 | `{serial_in, q[7:1]}` (right) |
| 0 | 0 | 0 | – | `q` |

`serial_out` shows the bit at the end that is leaving: `q[7]` for left shifts, `q[0]` for
right shifts.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `load`, `shift`, `dir`, `serial_in` | input | 1 |
| `din` | input | 8 |
| `q` | output | 8 |
| `serial_out` | output | 1 |
