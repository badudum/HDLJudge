### How it works

Add in 9 bits. The 9th bit (the carry out) is 1 exactly when the true sum exceeds 255. OR-ing
the 8-bit sum with eight copies of the carry forces every bit to 1 on overflow and leaves the sum
untouched otherwise:

```
200 + 100 = 1_0010_1100  → carry 1 → 0010_1100 | 1111_1111 = 1111_1111 (255)
100 + 100 = 0_1100_1000  → carry 0 → 1100_1000 | 0000_0000 = 1100_1000 (200)
```

### Watch out for
- `a + b` in an 8-bit context drops the carry: extend the operands first.
