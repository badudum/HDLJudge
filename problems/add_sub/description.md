Subtraction in two's complement is addition of the inverted operand plus one:

```
a − b  =  a + (~b) + 1
```

So a single adder does both jobs: XOR gates invert `b` when `sub = 1`, and `sub` itself is
the carry-in that adds the 1. Build this classic unit with a parameterized width.

### Interface

| Name | Kind | Width |
|------|------|-------|
| `N` | parameter / generic | default 8 (tested with 12) |
| `a`, `b` | input | N |
| `sub` | input | 1 |
| `y` | output | N |
| `cout` | output | 1 (carry out; for subtraction 1 = no borrow) |
