Credit-based flow control: the sender tracks how much buffer space the receiver has, so it never overflows it, even across a long pipelined link.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `in_valid` | input | 1 |
| `in_data` | input | 8 |
| `in_ready` | output | 1 |
| `tx_valid` | output | 1 |
| `tx_data` | output | 8 |
| `credit_ret` | input | 1 |
| `credits` | output | 3 |
