Adding three numbers normally takes two carry-propagate adders. A layer of full adders working in parallel (**carry-save**) turns three operands into two, so one adder suffices. Wallace-tree multipliers are built on this idea.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `a` | input | 8 |
| `b` | input | 8 |
| `c` | input | 8 |
| `sum` | output | 10 |
