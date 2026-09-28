A downstream block samples `strobe` with a slower, enable-based pipeline, so it needs single-cycle pulses with enough spacing. Encode the pulse-shape contract.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `strobe` | input | 1 |
