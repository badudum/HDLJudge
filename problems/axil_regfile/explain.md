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

Decode the register index from `addr[4:2]` and apply byte strobes: for each of the 4 byte lanes,
`if (wstrb[i]) reg[8*i +: 8] <= wdata[8*i +: 8]`. Addresses 0x20 and above get SLVERR and have no effect.

### Watch out for
- Reads and writes can be in flight at the same time: keep the two channel pairs independent.
- A read must return the register value at the time the read address is accepted.
