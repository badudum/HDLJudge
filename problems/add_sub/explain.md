### How it works

Subtraction is addition of the two's complement: `a − b = a + ~b + 1`. XOR gates invert b when `sub = 1`,
and `sub` doubles as the carry-in that supplies the `+1`:

```
       b ──[XOR sub]──┐
                      ├─[adder]── y
       a ─────────────┘    ↑ carry-in = sub
```

One adder serves both operations. In subtract mode the carry-out means "no borrow" (a ≥ b).

### Watch out for
- Declare the adder N + 1 bits wide to capture `cout`.
- The judge instantiates N = 12, so size everything from the parameter.
