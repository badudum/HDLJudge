A three-phase handshake (request, grant, completion) with timing windows and no overlapping transactions. Combine a temporal sequence with a small piece of checker state.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `gnt` | input | 1 |
| `done` | input | 1 |
