The classic dynamic branch predictor (the Smith predictor): a table of 2-bit saturating counters,
read in fetch to predict and updated at execute with the real outcome.

```
 00 strongly NT ⇄ 01 weakly NT ⇄ 10 weakly T ⇄ 11 strongly T
            predict not-taken        predict taken
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `pc` | input | 8 |
| `update` | input | 1 |
| `upd_pc` | input | 8 |
| `taken` | input | 1 |
| `pred` | output | 1 |
| `ctr` | output | 2 |
