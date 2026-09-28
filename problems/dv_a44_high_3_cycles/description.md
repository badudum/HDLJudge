Some interfaces require a minimum pulse width: once `en` goes high it must be held for at least
**3 cycles**. Write the assertion that catches pulses that are too short.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `en` | input | 1 |
