### How it works

Two steps, each a single arithmetic operation:

1. **Clear the garbage** above the field: `v = x & mask`, with `mask = (m << 1) − 1` and
   `m = 1 << n`.
2. **Extend the sign:** `(v ^ m) − m`. XOR flips the sign bit; the subtraction then borrows through
   every higher bit exactly when the original sign bit was 1.

```
n = 3, field = 1101 (−3):   v ^ m = 0101 (5),  5 − 8 = −3 = 1111 1111 1111 1101
n = 3, field = 0101 (+5):   v ^ m = 1101 (13), 13 − 8 = 5
```

### Watch out for
- For n = 15, `m << 1` overflows 16 bits to 0, and 0 − 1 = 0xFFFF is still the right mask.
