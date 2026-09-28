A 4-deep delay line should hold the last four input samples, one per stage:

```
edge:     1    2    3    4    5
din:      A    B    C    D    E
stage1:   A    B    C    D    E
stage2:        A    B    C    D
stage3:             A    B    C
stage4:                  A    B     ← dout
```

The implementation compiles, synthesizes and even passes a smoke test, but the delay is wrong.
There is **1 bug**. It is one of the most common beginner mistakes in HDL.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `din` | input | 8 |
| `taps` | output | 32 (`{stage4, stage3, stage2, stage1}`) |
| `dout` | output | 8 |
