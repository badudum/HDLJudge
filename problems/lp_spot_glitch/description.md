A junior engineer saved power by gating a counter's clock with a plain AND gate. In the lab the
counter sometimes counts **twice** in one cycle, and sometimes counts on half a pulse. Find and fix
the bug.

**1 bug** is hidden in the code.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `en` | input | 1 |
| `gclk` | output | 1 |
| `count` | output | 8 |
