### How it works

A four-phase handshake has a fixed order, req↑, ack↑, req↓, ack↓, and `req` may change only once `ack` has
caught up. That creates a race: an interrupt can arrive after the controller has asked for power-down but
before the PMU has acknowledged. The request can't be withdrawn, so the controller remembers the interrupt,
completes the handshake, and immediately requests power-up again:

```
RUN ─sleep─▶ REQ_OFF ─ack─▶ SLEEP ─wake─▶ REQ_ON ─!ack─▶ RUN (+ irq_out)
                 └─ wake while waiting: remember, go REQ_ON after ack
```

### Watch out for
- Several wake events outside RUN merge into one `irq_out` pulse.
- `pmu_req` is a pure function of the state.
