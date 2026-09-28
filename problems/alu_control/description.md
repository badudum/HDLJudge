In a classic single-cycle RISC-V datapath, the main control unit produces a 2-bit `alu_op`,
and a small **ALU control** decoder combines it with the instruction's `funct3` field and
bit 30 (`funct7_5`) to select the ALU operation.

| `alu_op` | Instruction class | ALU operation |
|----------|-------------------|---------------|
| `00` | load / store (address calc) | ADD |
| `01` | branch (compare)            | SUB |
| `10` | R-type (`add`, `sub`, …)    | from `funct3`, `funct7_5` |
| `11` | I-type (`addi`, `srai`, …)  | from `funct3`, `funct7_5` for shifts |

| `funct3` | R-type | I-type |
|----------|--------|--------|
| 000 | ADD, or SUB if `funct7_5` | ADD (always) |
| 001 | SLL | SLL |
| 010 | SLT | SLT |
| 011 | SLTU | SLTU |
| 100 | XOR | XOR |
| 101 | SRL, or SRA if `funct7_5` | SRL, or SRA if `funct7_5` |
| 110 | OR | OR |
| 111 | AND | AND |

Output codes: ADD 0, SUB 1, AND 2, OR 3, XOR 4, SLL 6, SRL 7, SRA 8, SLT 9, SLTU 10.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `alu_op` | input | 2 |
| `funct3` | input | 3 |
| `funct7_5` | input | 1 |
| `alu_ctrl` | output | 4 |
