A framer must assert `lock` right after it sees the sync word `1101` on its serial input. Check it with a sequence-based assertion.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `din` | input | 1 |
| `lock` | input | 1 |
