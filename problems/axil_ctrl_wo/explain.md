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

Only writes are meaningful here. CTRL is an ordinary register driving `ctrl_out`. PULSE is a
*command* register: writing 1 bits produces one-cycle strobes on `pulse_out`, and the register reads as nothing.

### Watch out for
- `pulse_out` must return to 0 on the cycle after the write.
- Every read still has to complete (with SLVERR and data 0).
