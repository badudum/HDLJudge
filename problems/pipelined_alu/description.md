Pipelining an ALU doubles its clock rate at the cost of latency. Build the two-stage version
with a global stall (as caused by a cache miss further down the pipeline).

```
          stage 1               stage 2
in ──▶ [valid,op,a,b] ──▶ ALU ──▶ [valid,y,zero] ──▶ out
                ↑ stall freezes both ↑
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `stall` | input | 1 |
| `valid_in` | input | 1 |
| `op` | input | 2 |
| `a` | input | 16 |
| `b` | input | 16 |
| `valid_out` | output | 1 |
| `y` | output | 16 |
| `zero` | output | 1 |
