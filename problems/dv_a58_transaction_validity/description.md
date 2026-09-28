A streaming interface sends packets of beats with a parity bit per beat and a `last` flag. Check beat integrity and packet framing.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `data` | input | 8 |
| `parity` | input | 1 |
| `last` | input | 1 |
