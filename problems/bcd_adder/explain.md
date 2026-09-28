### How it works

BCD stores each decimal digit in 4 bits, using only the codes 0000–1001. A binary add of two digits
and a carry gives 0 … 19. Whenever the result is **greater than 9**, adding 6 skips the six unused
codes and produces the correct digit, with the decimal carry set:

```
  7 + 5   = 12 = 0b0_1100   > 9 → + 6 = 0b1_0010 → carry 1, digit 2
  9 + 9+1 = 19 = 0b1_0011   > 9 → + 6 = 0b1_1001 → carry 1, digit 9
```

### Watch out for
- Compute the binary sum in **5 bits**, or 9 + 9 + 1 wraps before you test it.
- The correction test is `sum > 9`, not a check of the carry-out alone (10 … 15 produce no binary carry).
