### How it works

Pipelining splits a long combinational path with registers, so the clock can run faster at the cost of latency.
Each stage's registers carry the data **and** a valid bit, so bubbles (invalid cycles) flow through
without producing results. A global `stall` freezes every stage at once, as happens when a later stage waits for a
cache miss:

```
      stage 1                 stage 2
in ─▶ [v, op, a, b] ─▶ ALU ─▶ [v, y, zero] ─▶ out
```

### Watch out for
- Compute in stage 2 from the **stage-1 registers**, not from the inputs.
- `stall` must also stop new input from being taken.
