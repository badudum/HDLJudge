### How it works

A binary search finds the leading one in log₂ n steps. Is the upper half zero? If so, add 8 and look at the lower
half. Otherwise look at the upper half. Repeat with 4, 2, 1:

```
x = 0000 0000 0011 0101
upper 8 zero → n += 8, look at 0011 0101
upper 4 zero? no → look at 0011
upper 2 zero → n += 2 …  → n = 10
```

Count-leading-zeros units normalize floating-point results and drive priority logic.

### Watch out for
- x = 0 gives 16.
