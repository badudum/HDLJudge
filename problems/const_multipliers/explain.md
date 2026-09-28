### How it works

Any constant is a sum of powers of two, so a constant product is a sum of shifted copies of x. Using
**subtraction** often saves adders (canonical signed-digit form):

| constant | naive | better |
|----------|-------|--------|
| 7 = 111₂ | x<<2 + x<<1 + x (2 adders) | x<<3 − x (1 subtractor) |
| 10 = 1010₂ | x<<3 + x<<1 (1 adder) | same |
| 255 | 7 adders | x<<8 − x (1 subtractor) |

### Watch out for
- Extend x to 16 bits **before** shifting, or `x << 8` loses every bit.
