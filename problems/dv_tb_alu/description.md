Turn the tables: **you write the testbench**. It's graded by *mutation testing*: it runs against
the correct design and against hidden buggy variants, and it must pass the first and catch every
bug. Some bugs only show up in corner cases.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `a` | input | 8 |
| `b` | input | 8 |
| `op` | input | 3 |
| `y` | output | 8 |
| `carry` | output | 1 |
| `zero` | output | 1 |
| `neg` | output | 1 |
