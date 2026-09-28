Write a **behavioral (real-number) model** of an analog comparator with hysteresis.
This is a *modeling* problem: the design is not expected to be synthesizable —
the judge reports the synthesis result for information only.

The comparator watches the differential input `vd = vp - vn` (volts, `real` type)
and has a total hysteresis window `VH` (a `real` parameter / generic, default `0.1`):

| Condition        | Output `q`              |
|------------------|-------------------------|
| `vd >  VH / 2`   | `1`                     |
| `vd < -VH / 2`   | `0`                     |
| otherwise        | holds its previous value |

- There is no clock: `q` must react as soon as `vp` or `vn` changes.
- `q` starts at `0`.
- The testbench also instantiates the model with a non-default `VH`.

### Interface

| Name | Kind | Type |
|------|------|------|
| `VH` | parameter / generic | `real`, default `0.1` |
| `vp` | input  | `real` |
| `vn` | input  | `real` |
| `q`  | output | 1 bit (`logic` / `std_logic`) |

This problem is available in SystemVerilog (real-number modeling) and VHDL.
