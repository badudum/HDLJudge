Two masters, one memory: a **true dual-port RAM** lets both ports read and write independently in the same cycle. Define and implement a deterministic collision policy.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `we_a` | input | 1 |
| `addr_a` | input | 5 |
| `din_a` | input | 8 |
| `dout_a` | output | 8 |
| `we_b` | input | 1 |
| `addr_b` | input | 5 |
| `din_b` | input | 8 |
| `dout_b` | output | 8 |
