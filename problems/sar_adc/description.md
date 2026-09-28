A **successive-approximation (SAR) ADC** finds a digital code by binary search. It has a
DAC, one comparator, and a small digital controller. You design the controller. The hidden
testbench plays the analog part:

```
                 +-----------+    dac[7:0]    +-------------+
 start ────────▶ |           |──────────────▶ | 8-bit DAC   |──┐ vdac = dac/256·VREF
                 |  sar_ctrl |                +-------------+  │
 done,result ◀── |   (you)   |◀── cmp ──────────── (vin >= vdac) ◀── vin
                 +-----------+          testbench (analog model)
```

Conversion by binary search:

1. Try `dac = 1000_0000`. If `cmp = 1` (vin is at least that voltage) keep bit 7, else clear it.
2. Set bit 6, compare again; keep or clear it. Continue down to bit 0.
3. Publish the code on `result` with a one-cycle `done` pulse.

`cmp` reacts combinationally to `dac`, so it is valid by the next rising edge.

### Interface

| Port     | Direction | Width |
|----------|-----------|-------|
| `clk`    | input  | 1 |
| `rst`    | input  | 1 (synchronous, active high) |
| `start`  | input  | 1 |
| `cmp`    | input  | 1 (from the comparator) |
| `dac`    | output | 8 (to the DAC) |
| `done`   | output | 1 |
| `result` | output | 8 |
