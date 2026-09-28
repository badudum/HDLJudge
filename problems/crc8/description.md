Cyclic redundancy checks protect almost every link and storage format. Compute CRC-8 over a byte stream, processing one full byte per clock cycle.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `init` | input | 1 |
| `valid` | input | 1 |
| `data` | input | 8 |
| `crc` | output | 8 |
