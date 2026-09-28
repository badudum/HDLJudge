A 4-bit address can express 16 locations, but the memory behind it has only 12. Out-of-range accesses are a classic source of silent corruption. Catch them at the interface.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `we` | input | 1 |
| `re` | input | 1 |
| `addr` | input | 4 |
