A round-robin arbiter that isn't equal-share: each requester gets up to its weight in consecutive grants per turn. This is common in NoC routers and memory controllers for quality of service.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 3 |
| `gnt` | output | 3 |
