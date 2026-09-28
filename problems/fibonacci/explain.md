### How it works

Two registers hold the last two values, and each step computes `(a, b) ← (b, a + b)`. The interesting part is
overflow: F₂₄ = 46368 is the last Fibonacci number that fits in 16 bits. The next one (75025) doesn't, so the
generator must detect that **before** updating and stop.

### Watch out for
- Compute the sum one bit wider to detect overflow.
- After overflow, `en` is ignored until reset.
