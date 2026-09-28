### How it works

Shift the word against itself and combine it bitwise. That compares every bit with its neighbours
in parallel:

```
x            = 0111 0000
x >> 1       = 0011 1000
x >> 2       = 0001 1100
AND of all 3 = 0001 0000  → run3 = 1 (bit 4 starts a run of three)
```

For isolated ones, a bit must be 1 while both neighbours are 0: `x & ~(x << 1) & ~(x >> 1)`.

### Watch out for
- Shifts bring in zeros at the ends, which matches "bits outside the word count as 0".
