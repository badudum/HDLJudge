A configuration bus must not change while the block that uses it is enabled. Verify: once `en` is
high, `data` stays frozen until `en` drops. A new value may be loaded in the same cycle that `en`
rises.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `en` | input | 1 |
| `data` | input | 8 |
