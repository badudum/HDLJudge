### How it works

AXI4-Lite has five independent channels, each with its own VALID/READY handshake:

| channel | direction | carries |
|---------|-----------|---------|
| AW | master → slave | write address |
| W  | master → slave | write data + byte strobes |
| B  | slave → master | write response (OKAY = 0, SLVERR = 2) |
| AR | master → slave | read address |
| R  | slave → master | read data + response |

A write completes once AW and W have both been accepted (in either order) and the slave has returned B.
Reads are independent of writes.

The GPIO registers are only 8 bits wide, in lane 0. DATA_IN samples the asynchronous pins through a
2-flop synchronizer. TOGGLE is write-only: each 1 written flips the corresponding output bit, an atomic
read-modify-write done in hardware.

### Watch out for
- Reads of DATA_IN return the synchronized value, which lags the pins by two clocks.
- Writes with `wstrb[0] = 0` must not change anything.
