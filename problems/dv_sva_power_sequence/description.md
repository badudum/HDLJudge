Power-gated domains must follow a strict sequence:

```
power down:  iso_en ↑ → save (retention) → pwr_en ↓
power up:    pwr_en ↑ → (≥ 2 cycles) → restore → iso_en ↓
```

Violating it corrupts state or drives floating signals into the always-on logic. Write the
assertions that enforce the sequence.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `pwr_en` | input | 1 |
| `iso_en` | input | 1 |
| `save` | input | 1 |
| `restore` | input | 1 |
