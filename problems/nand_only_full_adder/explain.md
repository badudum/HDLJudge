### How it works

The 9-gate full adder is two 4-gate XORs plus one gate for the carry:

```
t1 = NAND(a, b)                         t2 = NAND(x1, cin)
x1 = NAND(NAND(a, t1), NAND(b, t1))     sum = NAND(NAND(x1, t2), NAND(cin, t2))
                        cout = NAND(t1, t2)
```

`cout = NAND(t1, t2) = a·b + x1·cin`, the standard carry equation, reusing the first NAND of each
XOR.

### Watch out for
- Primitive syntax: output first, `nand g (y, a, b);`.
