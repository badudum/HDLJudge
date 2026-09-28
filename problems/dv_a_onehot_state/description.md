One-hot FSMs are fast and easy to decode, but a single upset bit (or a bad next-state equation) leaves them in an illegal state. Write the invariant check.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `state` | input | 4 |
