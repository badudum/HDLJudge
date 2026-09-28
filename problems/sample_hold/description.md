A **sample-and-hold** (S/H) circuit freezes an analog voltage while an ADC converts it. Real
hold capacitors leak, so the held voltage slowly **droops**.

Write a discrete-time behavioral model. On every rising edge of `clk`:

| `track` | New `vout` |
|---------|------------|
| 1 | `vin` (track the input) |
| 0 | `vout * DROOP` (hold, with leakage) |

```
track: 1    1    0     0      0       1
vin  : 0.2  1.0  0.0   0.0    0.0     0.5
vout : 0.2  1.0  0.98  0.9604 0.9412  0.5      (DROOP = 0.98)
```

### Interface

| Name    | Kind | Type |
|---------|------|------|
| `DROOP` | parameter / generic | `real`, default `0.999` |
| `clk`   | input  | 1 bit |
| `track` | input  | 1 bit |
| `vin`   | input  | `real` |
| `vout`  | output | `real` |
