### How it works

Casting out nines works in decimal because 10 ≡ 1 (mod 9): a number and the sum of its digits
leave the same remainder. In hexadecimal, 16 ≡ 1 (mod 5), so the same trick works for 5:

```
x = h3·16³ + h2·16² + h1·16 + h0  ≡  h3 + h2 + h1 + h0   (mod 5)
```

The digit sum is at most 60 (6 bits). Fold again, since its upper bits are also worth 16: the
result is at most 18, and you can finish with a small lookup (0, 5, 10 or 15).

### Watch out for
- Size every intermediate sum so it can't wrap.
- `/`, `%`, `mod` and `rem` are rejected by the judge's rule check.
