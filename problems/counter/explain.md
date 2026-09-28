### How it works

The canonical sequential circuit: a register plus an incrementer. Everything happens on the rising edge:

```
always @(posedge clk)
    if (rst)     count <= 0;       // synchronous reset has priority
    else if (en) count <= count + 1;
```

A 4-bit register wraps from 15 to 0 by itself, with no compare needed.

### Watch out for
- Use nonblocking assignments (`<=`) in clocked blocks.
- A synchronous reset is tested *between* clock edges: it must not act immediately.
