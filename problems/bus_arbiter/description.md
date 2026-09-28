A classic shared-bus arbiter (AHB-style HLOCK): fixed priority, except that a master performing a locked sequence can't be interrupted.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 3 |
| `lock` | input | 3 |
| `gnt` | output | 3 |
| `owner` | output | 2 |
| `busy` | output | 1 |
