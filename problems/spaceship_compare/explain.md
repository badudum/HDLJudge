### How it works

One subtractor gives both answers. With `d = a − b` in 9 bits (both sign-extended):

| relation | d[8] (negative) | \|d (non-zero) | r |
|----------|-----------------|-----------------|---|
| a < b | 1 | 1 | 11 (−1) |
| a = b | 0 | 0 | 00 (0) |
| a > b | 0 | 1 | 01 (+1) |

So `r = {d[8], |d}`. The 2-bit pattern is already the two's-complement encoding of −1, 0 and +1.

### Watch out for
- Signed operands: extend with the sign bit (`{a[7], a}`), not with zero.
