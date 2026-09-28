Division is too expensive to do in one cycle, so most CPUs use an **iterative divider**. The
simplest is **restoring division**: long division in binary, producing one quotient bit per
clock, MSB first.

```
for i = 15 downto 0:
    rem = (rem << 1) | dividend[i]
    if rem >= divisor:  rem -= divisor;  q[i] = 1
    else:                                q[i] = 0
```

Exact timing, 16 iterations:

```
edge    E0      E1 … E15     E16         E17
start   1
busy    →1      1  …  1      →0
done                          →1          →0
q, r    ──────── old ───────  → result ──────
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `start` | input | 1 |
| `dividend`, `divisor` | input | 16 |
| `busy`, `done` | output | 1 |
| `quotient`, `remainder` | output | 16 |
