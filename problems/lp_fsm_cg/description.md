Fine-grained clock gating needs a controller that decides when a unit is idle. Gating too
eagerly wastes cycles on wake-ups; gating too late wastes power. This FSM gates after a short
idle timeout and reports how many cycles it saved.

```
      req|force_on          (always)
 OFF ───────────▶ WAKE ───────────▶ ON ──┐ req: idle = 0
  ▲                                  │  ◀┘
  └──────── 3rd consecutive idle ◀───┘
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `force_on` | input | 1 |
| `cg_en` | output | 1 |
| `ready` | output | 1 |
| `saved` | output | 16 |
