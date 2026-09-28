**Design for Test** makes manufacturing defects observable. The workhorse is **scan**: in test
mode every flip-flop is stitched into a long shift register (a *scan chain*), so the tester can
load any internal state and read any internal state through two pins.

A *mux-D scan flip-flop* is a normal flop with a 2:1 mux on its input:

```
          se
          │
 d  ──┐  ┌┴┐
      └─▶│M│
 si ─────│U│──▶ [D  Q] ──▶ q ──▶ (next flop's si)
         │X│
         └─┘
```

Build an 8-bit register with scan:

| `se` | Mode | Next `q` |
|------|------|----------|
| 0 | functional | `d` |
| 1 | scan shift | `{q[6:0], si}` |

`so = q[7]` is the end of the chain.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `se`, `si` | input | 1 |
| `d` | input | 8 |
| `q` | output | 8 |
| `so` | output | 1 |
