The always-on part of a power-managed SoC must never lose an interrupt, even one that arrives in
the middle of a power-down handshake, where aborting is not allowed.

```
pmu_req  __/‾‾‾‾‾‾‾‾‾‾‾‾‾‾\________
pmu_ack  _____/‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\____
state    RUN|REQ_OFF|SLEEP |REQ_ON|RUN
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `sleep_req` | input | 1 |
| `wake_irq` | input | 1 |
| `pmu_ack` | input | 1 |
| `pmu_req` | output | 1 |
| `asleep` | output | 1 |
| `irq_out` | output | 1 |
