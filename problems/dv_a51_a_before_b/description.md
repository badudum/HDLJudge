Initialization order checks: a peripheral may only be **used** (`b`) after it has been
**configured** (`a`) at least once since reset.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `a` | input | 1 |
| `b` | input | 1 |
