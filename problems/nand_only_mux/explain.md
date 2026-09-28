### How it works

A 2:1 multiplexer is the sum of products `y = a·s̄ + b·s`. De Morgan's law turns an AND-OR
network into a NAND-NAND network with the same shape, so you need one NAND per product term,
one NAND to combine them, and one NAND with both inputs tied together to invert `sel`.

```
sel ─┬─[NAND]── s̄ ──[NAND a]──┐
     │                         ├─[NAND]── y
     └──────────────[NAND b]───┘
```

### Watch out for
- Gate primitives take the **output first**: `nand g1 (out, in1, in2);`.
- Every net needs a `wire` declaration, or it becomes an implicit 1-bit wire. That is fine here,
  but a typo silently creates a new net.
