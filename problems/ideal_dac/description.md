Model an **ideal 8-bit digital-to-analog converter** with a registered input.

On each rising edge of `clk`, the DAC takes the 8-bit unsigned `code` and drives

```
vout = code / 256 * VREF
```

onto its `real` output. Between edges `vout` holds its value. Before the first edge `vout` is `0.0`.

This is a behavioral (real-number) model; synthesis is reported for information only.

### Interface

| Name   | Kind | Type |
|--------|------|------|
| `VREF` | parameter / generic | `real`, default `1.0` |
| `clk`  | input  | 1 bit |
| `code` | input  | 8 bits |
| `vout` | output | `real` |
