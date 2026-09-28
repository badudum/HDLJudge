Memories in servers, spacecraft and cars protect every word with an **ECC** code. The
classic choice is **SECDED**: *single-error correction, double-error detection*, an
extended Hamming code.

Your decoder receives an 8-bit code word protecting 4 data bits:

| Hamming position | 1 | 2 | 3 | 4 | 5 | 6 | 7 | — |
|------------------|---|---|---|---|---|---|---|---|
| role             | p1 | p2 | d0 | p4 | d1 | d2 | d3 | p0 (overall) |
| `code` bit       | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |

The encoder that produced the word used even parity:

```
p1 = d0 ^ d1 ^ d3        (positions 3, 5, 7)
p2 = d0 ^ d2 ^ d3        (positions 3, 6, 7)
p4 = d1 ^ d2 ^ d3        (positions 5, 6, 7)
p0 = XOR of code[6:0]    (so that all 8 bits XOR to 0)
```

Decode it:

- **no error** → `data = {d3,d2,d1,d0}`, both flags 0;
- **one bit flipped** (any of the 8) → correct it, `single_err = 1`;
- **two bits flipped** → `double_err = 1`, report the raw (uncorrected) data bits.

### Interface

| Port         | Direction | Width |
|--------------|-----------|-------|
| `code`       | input  | 8 |
| `data`       | output | 4 |
| `single_err` | output | 1 |
| `double_err` | output | 1 |
