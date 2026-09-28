Dynamic power is proportional to how often wires switch. Build a hardware activity monitor that reports toggles per window and flags hot phases, as used by power governors and power-aware verification.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `bus` | input | 8 |
| `threshold` | input | 8 |
| `activity` | output | 8 |
| `hot` | output | 1 |
