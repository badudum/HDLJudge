Generate the **Fibonacci sequence** in hardware, one term per enabled clock:

```
F0 = 0, F1 = 1, Fn = Fn-1 + Fn-2
0, 1, 1, 2, 3, 5, 8, 13, 21, 34, … , 28657, 46368 | 75025 does not fit in 16 bits
```

The output is 16 bits. When the next term would overflow, the generator must freeze on the
last valid term and raise a sticky `overflow` flag. Sticky means it stays set until reset.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `en` | input | 1 |
| `fib` | output | 16 |
| `overflow` | output | 1 |
