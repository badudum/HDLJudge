A single adder/subtractor serves both unsigned and signed arithmetic. What differs is how you
interpret its flags:

- **carry** answers "did the *unsigned* result fit?"
- **overflow** answers "did the *signed* result fit?"

| `a` | `b` | op | `y` | carry | ovf | why |
|-----|-----|----|-----|-------|-----|-----|
| 0xFF | 0x01 | + | 0x00 | 1 | 0 | 255 + 1 overflows unsigned; −1 + 1 = 0 is fine signed |
| 0x7F | 0x01 | + | 0x80 | 0 | 1 | 127 + 1 = 128 fits unsigned, not signed |
| 0x80 | 0x80 | + | 0x00 | 1 | 1 | both |
| 0x00 | 0x01 | − | 0xFF | 0 | 0 | borrow: carry-out is 0 |

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `a`, `b` | input  | 8 |
| `sub`   | input  | 1 |
| `y`     | output | 8 |
| `carry` | output | 1 |
| `ovf`   | output | 1 |
