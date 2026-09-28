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

Here every write is answered with SLVERR, but the write channels must still complete their
handshakes (otherwise the master hangs). The EVENTS counter runs all the time, and STATUS is
simply the input `status_in` captured when the read address is accepted.

### Watch out for
- Latch AW and W independently: the master may send them in either order or in different cycles.
- Hold BVALID/RVALID (and their payload) until the master's READY.
