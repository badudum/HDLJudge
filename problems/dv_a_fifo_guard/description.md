The two classic FIFO interface bugs: writing into a full FIFO and reading from an empty one. Guard the interface with assertions.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `push` | input | 1 |
| `pop` | input | 1 |
| `full` | input | 1 |
| `empty` | input | 1 |
