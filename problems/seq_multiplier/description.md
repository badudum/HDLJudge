A **multicycle multiplier** trades speed for area: instead of a big array of adders it uses
one adder and processes one multiplier bit per clock (the pencil-and-paper shift-add
algorithm).

```
        a = 0000_0111 (7)
      × b = 0000_0110 (6)
step 1: b[0]=0 → acc += 0
step 2: b[1]=1 → acc += 7<<1  = 14
step 3: b[2]=1 → acc += 7<<2  = 28  → 42
…
```

Timing is **exact** (it's part of the interface other blocks rely on):

```
edge     E0     E1 … E7     E8        E9
start    1
busy     →1     1  …  1     →0
done                         →1        →0
product  ─────── old ──────  → a·b ───────
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `start` | input | 1 |
| `a`, `b` | input | 8 |
| `busy`, `done` | output | 1 |
| `product` | output | 16 |
