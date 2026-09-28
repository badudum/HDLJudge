Issue logic must not send an instruction to a functional unit that is still busy with a
multi-cycle operation (a divider, a multiplier…). That would be a **structural hazard**.
Build the tracker that knows which units are busy.

```
cycle:        1    2    3    4    5
issue FU2/L3: ✓
busy[2]:      1    1    1    0    0
accepted:     1    0    0    0    0
issue FU2/L2:      ✗ (busy)       ✓
busy[2]:                          1    1
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `issue` | input | 1 |
| `fu` | input | 2 |
| `latency` | input | 3 (cycles, 1–7; 0 is rejected) |
| `busy` | output | 4 |
| `accepted` | output | 1 |
