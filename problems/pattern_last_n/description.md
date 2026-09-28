Monitors often ask "has this event happened at least K times in the last N cycles?", e.g. an
error-rate alarm or a lock detector. Build a sliding-window counter for **N = 12**, **K = 8**:

```
window = the last 12 samples of din
count  = number of 1s in the window
alarm  = count ≥ 8
```

The efficient way is to keep the window in a shift register and update the count with just
the bit entering and the bit leaving each cycle.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `din` | input | 1 |
| `count` | output | 4 |
| `alarm` | output | 1 |
