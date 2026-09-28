Sigma-delta (ΣΔ) converters trade amplitude resolution for speed: a 1-bit quantizer inside a
feedback loop produces a fast bit stream whose **average density of ones** tracks the input.
Every audio codec and most precision ADCs use one.

Model the classic **first-order** modulator:

```
            +-----+      +------------+      +------------+
 vin ──(+)──| Σ   |──────| integrator |──────| comparator |──┬── bit_out
        ▲-  +-----+      +------------+      +------------+  │
        └───────────────── 1-bit DAC: ±1.0 ◀─────────────────┘
```

On each rising edge of `clk` (outside reset):

```
fb      = bit_out ? +1.0 : -1.0      (DAC of the previous bit)
integ   = integ + vin - fb
bit_out = (integ >= 0.0)
```

`rst` (synchronous) sets `integ = 0.0` and `bit_out = 0`.

For a constant input, the fraction of ones in the stream converges to `(vin + 1) / 2`.

### Interface

| Port      | Direction | Type |
|-----------|-----------|------|
| `clk`     | input  | 1 bit |
| `rst`     | input  | 1 bit |
| `vin`     | input  | `real`, −1 … 1 |
| `bit_out` | output | 1 bit |
