A *precedence* property looks **backwards**: an effect (`done`) is legal only if its cause
(`start`) happened recently enough. Here: at most **10 cycles** earlier, and strictly before.

Pure SVA can express "A is followed by B" directly. The reverse direction is usually written with
a little modeling code: a counter tracking the cycles since the last `start`.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `start` | input | 1 |
| `done` | input | 1 |
