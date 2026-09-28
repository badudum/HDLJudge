### How it works

The one-hot trick in a single line: `x & (x − 1)` clears the lowest set bit. Apply it once,
and a two-hot value becomes one-hot. Then apply the one-hot test to the result:

```
x          = 0010 0100      (two bits)
y = x&(x-1)= 0010 0000      (lowest removed → one bit left)
y & (y-1)  = 0000 0000      and y ≠ 0  →  two = 1
```

### Watch out for
- y must be **non-zero**: a one-hot or zero x gives y = 0.
- A popcount adder tree also works but is much larger (and misses the point of the puzzle).
