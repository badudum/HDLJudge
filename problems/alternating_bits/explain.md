### How it works

Shift the word by one position and XOR it with itself. Bit i of `x ^ (x >> 1)` is 1 exactly when
bits i and i+1 differ. An alternating word therefore produces all ones in bits 0 … 14. Bit 15
compares with the zero shifted in, so ignore it.

```
x          = 0101 0101 0101 0101
x >> 1     = 0010 1010 1010 1010
x ^ (x>>1) = 0111 1111 1111 1111   → &y[14:0] = 1
```

### Watch out for
- Only compare the 15 meaningful positions.
