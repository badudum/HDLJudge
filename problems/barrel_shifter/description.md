Implement a **barrel shifter**: it shifts or rotates by any amount in a single combinational
step. It is a core part of every CPU's ALU and of floating-point normalization.

| `op` | Operation | Example (WIDTH=8, `din` = 1001_0110, `shamt` = 2) |
|------|-----------|--------------------------------------------------|
| 00 | SLL, shift left logical      | 0101_1000 |
| 01 | SRL, shift right logical     | 0010_0101 |
| 10 | SRA, shift right arithmetic  | 1110_0101 |
| 11 | ROR, rotate right            | 1010_0101 |

The width is a parameter (a power of two). The judge instantiates **WIDTH = 16**, so
`shamt` is 4 bits.

### Interface

| Name | Kind | Width |
|------|------|-------|
| `WIDTH` | parameter / generic | default 8 |
| `din`   | input  | WIDTH |
| `shamt` | input  | log₂(WIDTH) |
| `op`    | input  | 2 |
| `dout`  | output | WIDTH |
