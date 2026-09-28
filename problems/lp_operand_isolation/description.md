**Operand isolation** stops an idle functional unit from toggling. It's the combinational-logic counterpart of clock gating, and synthesis tools insert it automatically when they can prove a result is unused.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `en` | input | 1 |
| `op` | input | 1 |
| `a` | input | 8 |
| `b` | input | 8 |
| `y` | output | 16 |
| `add_in` | output | 16 |
| `mul_in` | output | 16 |
