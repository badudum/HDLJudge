A retention counter from a sleep-capable sensor hub. After waking up, the firmware sometimes
reads a count of **0** or **255** instead of the value it had before sleeping, and the count
occasionally comes back off by one.

**3 bugs** are hidden in the code.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `pwr_on` | input | 1 |
| `save` | input | 1 |
| `restore` | input | 1 |
| `en` | input | 1 |
| `count_out` | output | 8 |
