Real amplifiers cannot change their output voltage infinitely fast. The maximum rate of change
is the **slew rate** (V/s). Large steps come out as ramps, while small signals pass
unaffected.

Model an ideal slew-rate limiter in discrete time. On every rising edge of `clk` (period `TS`):

```
step = SR * TS                    (largest allowed change per edge)
d    = vin - vout
vout = vout + clamp(d, -step, +step)
```

```
vin :  1.0  1.0  1.0  1.0  1.0  1.0  1.05
vout:  0.2  0.4  0.6  0.8  1.0  1.0  1.05      (step = 0.2 V)
```

### Interface

| Name   | Kind | Type |
|--------|------|------|
| `SR`   | parameter / generic | `real`, V/s, default `1.0e7` |
| `TS`   | parameter / generic | `real`, s, default `10.0e-9` |
| `clk`  | input  | 1 bit |
| `vin`  | input  | `real` |
| `vout` | output | `real` |
