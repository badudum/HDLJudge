### How it works

Gosper's hack, step by step on x = 0011 1000:

1. `s = x & -x = 0000 1000`: the lowest set bit.
2. `r = x + s = 0100 0000`: the lowest run of ones carries into the next zero.
3. `ones = ((x ^ r) >> 2) / s = 0000 0011`: the bits that "fell off", moved back to the bottom.
4. `nxt = r | ones = 0100 0011`.

Since s is a power of two, dividing by it is a right shift by its index, and that index comes from
four OR-masks (0xAAAA, 0xCCCC, 0xF0F0, 0xFF00) without any loop.

### Watch out for
- A carry out of bit 15 in step 2 means no larger value exists: output 0.
