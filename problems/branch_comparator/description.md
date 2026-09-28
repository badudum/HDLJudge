The branch unit of a RISC-V pipeline decides whether a conditional branch is **taken**. It
compares two register values according to the instruction's `funct3`:

| `funct3` | Instruction | Taken when |
|----------|-------------|------------|
| 000 | BEQ  | `a == b` |
| 001 | BNE  | `a != b` |
| 100 | BLT  | `a < b` (signed) |
| 101 | BGE  | `a >= b` (signed) |
| 110 | BLTU | `a < b` (unsigned) |
| 111 | BGEU | `a >= b` (unsigned) |
| 010, 011 | — | never |

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `a`, `b` | input | 32 |
| `funct3` | input | 3 |
| `taken` | output | 1 |
