An edge detector should produce `pulse = 1` exactly in the cycles where its input `a` has just
risen. Verify that relation with assertions, in both directions: no missing pulses and no spurious
ones.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `a` | input | 1 |
| `pulse` | input | 1 |
