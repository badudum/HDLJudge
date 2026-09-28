Protocol FSMs are verified by checking that only **legal arcs** of the state diagram are taken:

```
      ┌──┐          ┌──┐
      ▼  │          ▼  │
    IDLE ─┴─▶ REQ ──┴─▶ XFER ─▶ DONE ─┐
      ▲       │                 │  ▲ │
      └───────┘                 └──┘ │
      ▲──────────────────────────────┘
```

Write a checker that fires on any illegal transition of the 2-bit `state` signal.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `state` | input | 2 |
