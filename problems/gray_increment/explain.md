### How it works

In reflected Gray code consecutive values differ in exactly one bit, but *which* bit is not
obvious. The simplest correct method converts to binary, increments, and converts back:

- Gray → binary is a **prefix XOR** from the top bit down: `b[i] = g[7] ^ g[6] ^ … ^ g[i]`.
  Three shift-XOR steps compute it without a loop: shifts of 1, 2 and 4.
- Binary → Gray is a single step: `n ^ (n >> 1)`.

| n | binary | Gray |
|---|--------|------|
| 0 | 000 | 000 |
| 1 | 001 | 001 |
| 2 | 010 | 011 |
| 3 | 011 | 010 |
| 4 | 100 | 110 |

### Watch out for
- The increment must wrap: 255 → 0, and its Gray code 1000_0000 → 0000_0000.
