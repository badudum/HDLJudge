Decode a 32-bit **RISC-V RV32I** instruction: classify its format, extract the sign-extended
immediate, and generate the main datapath control signals.

| Opcode | Class | Format | reg_write | mem_read | mem_write | branch | jump |
|--------|-------|--------|:---:|:---:|:---:|:---:|:---:|
| 0110011 | OP (`add`, …)     | R | 1 | | | | |
| 0010011 | OP-IMM (`addi`, …) | I | 1 | | | | |
| 0000011 | LOAD              | I | 1 | 1 | | | |
| 1100111 | JALR              | I | 1 | | | | 1 |
| 0100011 | STORE             | S | | | 1 | | |
| 1100011 | BRANCH            | B | | | | 1 | |
| 0110111 | LUI               | U | 1 | | | | |
| 0010111 | AUIPC             | U | 1 | | | | |
| 1101111 | JAL               | J | 1 | | | | 1 |
| other   | —                 | 7 | | | | | |

Immediate layouts (bit 0 of B and J immediates is always 0):

```
I:  imm[11:0]  = instr[31:20]
S:  imm[11:0]  = {instr[31:25], instr[11:7]}
B:  imm[12:1]  = {instr[31], instr[7], instr[30:25], instr[11:8]}
U:  imm[31:12] = instr[31:12]
J:  imm[20:1]  = {instr[31], instr[19:12], instr[20], instr[30:21]}
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `instr` | input | 32 |
| `fmt` | output | 3 |
| `imm` | output | 32 |
| `reg_write`, `mem_read`, `mem_write`, `branch`, `jump` | output | 1 |
