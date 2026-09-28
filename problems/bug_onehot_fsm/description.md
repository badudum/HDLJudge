One-hot FSMs use one flip-flop per state, which makes next-state logic fast and simple. Each
next-state bit is just the OR of its incoming transitions. The catch: nothing guarantees that
*exactly one* bit is hot. The reset value and the equations must keep it that way.

```
        go            always          done           always
 IDLE ─────▶ LOAD ─────────▶ RUN ─────────▶ FLUSH ─────────▶ IDLE
  ↺ !go                       ↺ !done
```

After reset the controller never responds, and when it does run, the status register sometimes
shows two states at once. **2 bugs**.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `go`, `done` | input | 1 |
| `state` | output | 4 (`{FLUSH, RUN, LOAD, IDLE}`) |
| `busy` | output | 1 |
