Model a first-order **RC low-pass filter** as a discrete-time real-number model.

A continuous RC filter obeys `dVout/dt = (Vin - Vout) / TAU`. If `Vin` is held constant
for one time step `TS`, the exact solution over that step is

```
alpha = 1 - exp(-TS / TAU)
vout_next = vout + (vin - vout) * alpha
```

Your model must apply this update on every **rising edge** of `clk`, using the value of
`vin` present at that edge. The testbench drives `clk` with period `TS`.

- `TAU` (time constant) and `TS` (time step) are `real` parameters / generics in
  **seconds**, with defaults `TAU = 1.0e-6` and `TS = 10.0e-9`.
- `vout` starts at `0.0`.
- Results are compared against the exact recurrence with an absolute tolerance of `1e-9` V.
  The testbench also checks a physical sanity point: after a unit step, `vout` reaches
  ≈ 63.2 % after one time constant.
- A second instance with `TAU = 200e-9` is also tested.

### Interface

| Name   | Kind | Type |
|--------|------|------|
| `TAU`  | parameter / generic | `real`, default `1.0e-6` |
| `TS`   | parameter / generic | `real`, default `10.0e-9` |
| `clk`  | input  | 1 bit |
| `vin`  | input  | `real` |
| `vout` | output | `real` |
