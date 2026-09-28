Check an arbiter from the outside: grants must be exclusive, only go to requesters, and no master may win twice in a row while someone else is waiting.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 4 |
| `gnt` | input | 4 |
