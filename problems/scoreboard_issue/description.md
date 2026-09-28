A **scoreboard** is the simplest way to let a pipeline keep issuing while long-latency
operations (loads, multiplies) are in flight. It keeps one *pending* bit per register:

- an instruction issues only if none of its sources is pending (**RAW**) and its destination
  is not pending (**WAW**);
- issuing sets the destination's pending bit;
- a writeback clears it.

```
edge 1: issue  mul r3 ← r1, r2     pending = {r3}
edge 2: issue  add r4 ← r3, r1     RAW on r3 → stall
edge 3: wb r3 + issue add again     pending = {r4}   (bypass: wb clears first)
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `issue_valid`, `wb_valid` | input | 1 |
| `rd`, `rs1`, `rs2`, `wb_rd` | input | 3 |
| `issued` | output | 1 |
| `pending` | output | 8 |
