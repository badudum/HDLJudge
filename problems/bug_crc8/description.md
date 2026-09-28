This CRC-8 block never matches the reference software, and it sometimes fails to restart at a
packet boundary.

**2 bugs** are hidden in the code.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `init` | input | 1 |
| `valid` | input | 1 |
| `data` | input | 8 |
| `crc` | output | 8 |
