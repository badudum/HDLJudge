### How it works

Asynchronous reset assertion is safe: every flop goes to its reset value regardless of the clock. The
**release** is the danger: if reset deasserts close to a clock edge, some flops leave reset one cycle
before others, or go metastable. The synchronizer releases reset through two flops clocked by `clk`, so
the whole domain leaves reset on the same clean edge:

```
arst_n ─┬──────────────┐ (async clear of both flops)
1'b1 ──[FF1]──[FF2]── rst_n
```

### Watch out for
- Both flops need the asynchronous clear.
- `rst_n` rises at the **second** rising edge after `arst_n` rises.
