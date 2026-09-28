A GPU streaming multiprocessor hides latency by keeping several **warps** resident and
issuing an instruction from a different warp each cycle. The **warp scheduler** picks the
warp.

This scheduler is round-robin with a hazard window: after a warp issues, its next
instruction can't go for **two cycles**, since the result isn't ready in the pipeline yet.

```
ready:        1111 1111 1111 1111 1111 0100 0100 0100 0100
issue_warp:     0    1    2    3    0    -    2    -    -     (then 2 again)
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst` | input | 1 |
| `ready` | input | 4 |
| `issue_valid` | output | 1 |
| `issue_warp` | output | 2 |
