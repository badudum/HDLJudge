### How it works

All three outputs come from how subtraction borrows:

```
x        = 0101 1000
x − 1    = 0101 0111     (lowest 1 cleared, zeros below it become ones)
-x       = 1010 1000     (= ~x + 1: bits above the lowest 1 flip)
x & -x   = 0000 1000     iso:   lowest set bit
x & (x-1)= 0101 0000     clr:   lowest set bit cleared
~x&(x-1) = 0000 0111     tmask: the trailing zeros as ones
```

These are the building blocks of priority logic, bit-set iteration and the trailing-zero count.

### Watch out for
- For x = 0, `x − 1` is all ones, so `tmask` is 0xFFFF, which is what the spec asks for.
