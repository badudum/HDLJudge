A FIFO's status outputs must be consistent with each other and with the traffic. Write the checker that would catch most FIFO bugs from the outside.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `push` | input | 1 |
| `pop` | input | 1 |
| `full` | input | 1 |
| `empty` | input | 1 |
| `count` | input | 4 |
