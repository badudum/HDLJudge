Signals crossing from a low-voltage domain to a high-voltage one need a **level shifter**: a 0.8 V logic high doesn't reliably turn off a 1.2 V PMOS. Model one, with an input Schmitt trigger and power-aware behavior.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `vin` | input | real |
| `vddl` | input | real |
| `vddh` | input | real |
| `vout` | output | real |
