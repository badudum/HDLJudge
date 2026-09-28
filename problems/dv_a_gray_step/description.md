Gray-coded pointers are only CDC-safe if they really change one bit at a time. Assert it.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `cnt` | input | 4 |
