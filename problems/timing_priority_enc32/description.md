Priority encoders sit in arbiters, leading-zero counters and free-list allocators, often on the critical path. Meet a logic-depth budget that a naive chain misses.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `req` | input | 32 |
| `valid` | output | 1 |
| `idx` | output | 5 |
