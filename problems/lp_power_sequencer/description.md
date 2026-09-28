The power management unit's job in one FSM: shut a domain down and bring it back up in exactly
the right order. A wrong order corrupts state (saving after power is gone) or leaks garbage into
the always-on logic (removing isolation before restoring).

```
ON → STOP_CLK → ISOLATE → SAVE → PWR_OFF ─(ack=0)→ OFF
 ▲                                                 │ wake_req
 └── DEISO ← RESTORE ←─(ack=1)─ PWR_ON ◀───────────┘
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `sleep_req` | input | 1 |
| `wake_req` | input | 1 |
| `pwr_ack` | input | 1 |
| `clk_en` | output | 1 |
| `iso_en` | output | 1 |
| `save` | output | 1 |
| `restore` | output | 1 |
| `pwr_en` | output | 1 |
| `asleep` | output | 1 |
