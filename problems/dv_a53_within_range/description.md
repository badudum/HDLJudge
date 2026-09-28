A sensor interface reports temperatures that are only meaningful while `valid` is high. Check the value range, but only when it counts.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `temp` | input | 8 |
