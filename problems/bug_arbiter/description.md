The round-robin arbiter from problem 28 was re-implemented for a new bus, and the system team
reports that **master 0 starves** under heavy load. Also, a **phantom grant** stays asserted
after all masters go idle.

**2 bugs** are hidden in the starter code.

```
req   : 1111 1111 1111 1111 0000
grant : 0001 0010 0100 1000 0000     (expected)
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst` | input | 1 |
| `req` | input | 4 |
| `grant` | output | 4 |
