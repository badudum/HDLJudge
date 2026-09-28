Scan insertion replaces the flops of a design with scan flops. In test mode they form a shift
chain, and in functional mode the design behaves exactly as before. This is how an ATPG tool
tests the counter's increment logic without counting through all its states.

Build a 4-bit counter with its flops scan-inserted:

| `se` | Next `count` |
|------|--------------|
| 0 | `en ? count + 1 : count` (functional) |
| 1 | `{count[2:0], si}` (scan shift) |

```
ATPG pattern: shift in 1,1,1,0 → count = 1110
              capture (se=0, en=1) → count = 1111, tc = 1   ← tests the incrementer
              shift out → so = 1,1,1,1
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `en`, `se`, `si` | input | 1 |
| `count` | output | 4 |
| `tc`, `so` | output | 1 |
