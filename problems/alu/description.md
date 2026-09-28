Build the arithmetic-logic unit of a small RISC-style CPU, with a configurable data width.

| `op` | Mnemonic | `y` |
|------|----------|-----|
| 0  | ADD  | `a + b` |
| 1  | SUB  | `a - b` |
| 2  | AND  | `a & b` |
| 3  | OR   | `a \| b` |
| 4  | XOR  | `a ^ b` |
| 5  | NOR  | `~(a \| b)` |
| 6  | SLL  | `a << b[s-1:0]` |
| 7  | SRL  | `a >> b[s-1:0]` (logical) |
| 8  | SRA  | `a >>> b[s-1:0]` (arithmetic) |
| 9  | SLT  | `1` if `a < b` as **signed** numbers, else `0` |
| 10 | SLTU | `1` if `a < b` as **unsigned** numbers, else `0` |
| 11–15 | — | `0` |

(`s = log₂(WIDTH)`: the shift amount uses the low bits of `b`.)

Flags, valid for every operation:

| Flag | Meaning |
|------|---------|
| `zero`     | `y == 0` |
| `negative` | MSB of `y` |
| `carry`    | ADD: carry-out. SUB: carry-out of `a + ~b + 1` (1 = no borrow). Otherwise 0 |
| `overflow` | ADD/SUB: two's-complement overflow. Otherwise 0 |

### Interface

| Name | Kind | Width |
|------|------|-------|
| `WIDTH` | parameter / generic | default 8 (tested with 16) |
| `a`, `b` | input | WIDTH |
| `op` | input | 4 |
| `y` | output | WIDTH |
| `zero`, `carry`, `overflow`, `negative` | output | 1 |
