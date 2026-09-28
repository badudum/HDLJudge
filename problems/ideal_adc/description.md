Write a behavioral model of an **ideal 8-bit sampling ADC** with reference voltage
`VREF` (a `real` parameter / generic, default `1.0`).

On every **rising edge** of `clk` the ADC samples the analog input `vin` (a `real`,
in volts) and updates its output:

```
code = floor(vin / VREF * 256)      clamped to the range 0 ... 255
```

Between rising edges `code` holds its value (sample-and-hold behavior).
Before the first edge `code` is `0`.

| `vin` (VREF = 1.0) | `code` |
|--------------------|--------|
| `-0.2`             | 0      |
| `0.00390625` (1 LSB) | 1    |
| `0.5`              | 128    |
| `0.999`            | 255    |
| `1.3`              | 255    |

The testbench also instantiates your model with `VREF = 2.0`.

### Interface

| Name   | Kind | Type |
|--------|------|------|
| `VREF` | parameter / generic | `real`, default `1.0` |
| `clk`  | input  | 1 bit |
| `vin`  | input  | `real` |
| `code` | output | 8 bits |
