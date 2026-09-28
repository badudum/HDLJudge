Liveness in bounded form: no requester may wait more than four cycles. Unbounded "eventually" properties can't be checked by simulation; bounded ones can.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 4 |
| `gnt` | input | 4 |
