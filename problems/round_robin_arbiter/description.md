When several masters share one resource (a bus, a memory port, a crossbar output), an
**arbiter** decides who goes next. A fixed-priority arbiter can starve low-priority masters
forever. A **round-robin** arbiter rotates the priority so that every requester is served.

Design a 4-requester round-robin arbiter with a **registered, one-hot grant**:

- A 2-bit pointer `ptr` names the requester with the highest priority (0 after reset).
- On each rising edge, starting at `ptr` and going upward (wrapping from 3 to 0), the first
  requester with `req[i] = 1` wins: `grant <= 1 << i`, `ptr <= (i + 1) mod 4`.
- If nobody requests: `grant <= 0` and `ptr` is unchanged.

```
req   : 1111 1111 1111 1111 1001 1001 0000 0100
grant : 0001 0010 0100 1000 0001 1000 0000 0100
ptr→    1    2    3    0    1    0    0    3
```

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `clk`   | input  | 1 |
| `rst`   | input  | 1 (synchronous, active high) |
| `req`   | input  | 4 |
| `grant` | output | 4 (one-hot or zero) |
