### How it works

Each binary bit is the XOR of all Gray bits at or above it, a **prefix (scan) computation**.
The doubling trick computes every prefix in log₂(32) = 5 levels:

```
t1 = g  ^ (g  >> 1)    each bit now covers 2 Gray bits
t2 = t1 ^ (t1 >> 2)    … 4
t3 = t2 ^ (t2 >> 4)    … 8
t4 = t3 ^ (t3 >> 8)    … 16
b  = t4 ^ (t4 >> 16)   … all 32
```

The same structure is the Kogge-Stone parallel-prefix adder.

### Watch out for
- A `for` loop computing `b[i] = b[i+1] ^ g[i]` synthesizes to a 31-deep chain.
