Dividing by an even number is easy, and odd ratios with a 50 % duty cycle are a classic interview
problem. The output must be high for one and a half input periods, which is impossible with
rising-edge flops alone.

```
clk      _/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_
clk_out  _/‾‾‾‾‾\_____/‾‾‾‾‾\_____
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `clk_out` | output | 1 |
