A classic interview puzzle: decide whether a 16-bit word is **one-hot** using only
combinational logic — and without loops or population-count helpers.

| Output    | Meaning |
|-----------|---------|
| `onehot`  | `1` when **exactly one** bit of `x` is set |
| `onehot0` | `1` when **at most one** bit of `x` is set (zero is allowed) |

A straightforward solution counts the ones with a loop. Here loops, `generate`,
`$onehot`, `$onehot0` and `$countones` are rejected by the judge before compilation.
Find the arithmetic trick instead.

### Interface

| Port      | Direction | Width |
|-----------|-----------|-------|
| `x`       | input  | 16 |
| `onehot`  | output | 1 |
| `onehot0` | output | 1 |
