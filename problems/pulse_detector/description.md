Some interfaces signal events with **exactly one-cycle-wide** strobes. A glitch filter or
protocol checker must tell those apart from longer levels.

Detect the sample pattern **0 → 1 → 0** on `din` (a pulse exactly one clock wide):

```
din   : 0 0 1 0 0 1 1 0 1 0 1 0
pulse : 0 0 0 1 0 0 0 0 0 1 0 1     (one cycle after the closing 0)
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `din` | input | 1 |
| `pulse` | output | 1 |
