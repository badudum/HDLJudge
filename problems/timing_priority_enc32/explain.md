### How it works

Divide and conquer: split the request vector in two, encode both halves, and choose the lower
half if it has any bit set. The index gains one bit per level:

```
level 1: 16 pairs   → valid + 1-bit index
level 2:  8 quads   → valid + 2-bit index
…
level 5:  1 word    → valid + 5-bit index
```

Each level is one OR plus one mux, so the depth grows with log₂ n instead of n.

### Watch out for
- "Lowest set bit wins": in each merge, prefer the **lower** half.
