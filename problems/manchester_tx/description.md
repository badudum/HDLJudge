Manchester code (used by 10BASE-T Ethernet, and similar to RFID and DALI encodings) sends every bit as a transition, so the clock can be recovered from the data.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `load` | input | 1 |
| `data` | input | 8 |
| `tx` | output | 1 |
| `busy` | output | 1 |
