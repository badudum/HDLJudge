The **integrated clock gate** (ICG) is the most important low-power cell. It stops the clock of an
idle block, and it's built from a latch and an AND gate so that the gated clock never glitches.
The naive `assign gclk = clk & en;` chops clock pulses whenever `en` changes while `clk` is high.

```
            ┌───────┐
en ──┬──────│D     Q│─────┐
test_en ─┘  │ latch │     ├─(AND)── gclk
clk ──o─────│G      │     │
      │     └───────┘     │
      └───────────────────┘
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `en` | input | 1 |
| `test_en` | input | 1 |
| `gclk` | output | 1 |
