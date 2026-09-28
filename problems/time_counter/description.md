Convert a 1 kHz tick into a clock display: milliseconds, seconds, minutes and hours of a 24-hour
day. A `load` input presets the time, which is also how the testbench reaches the interesting
roll-overs without waiting a simulated day.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `tick_ms` | input | 1 |
| `load` | input | 1 |
| `ld_ms` | input | 10 |
| `ld_sec` | input | 6 |
| `ld_min` | input | 6 |
| `ld_hr` | input | 5 |
| `ms` | output | 10 |
| `sec` | output | 6 |
| `min` | output | 6 |
| `hr` | output | 5 |
