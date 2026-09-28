Bus masters often have a limit on outstanding transactions (IDs, buffer entries). Check the limit, and check that responses never outnumber requests.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `rsp` | input | 1 |
