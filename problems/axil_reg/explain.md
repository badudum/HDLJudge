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

The minimal slave: one register at address 0. Build a write path (collect AW and W, update the register
with byte strobes, raise BVALID) and a read path (accept AR, raise RVALID with the data).

### Watch out for
- Don't wait for AWVALID before accepting W (or the other way round): the master may present them in either order.
- BVALID must not rise before both AW and W were accepted.
