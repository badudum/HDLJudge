### How it works

When a new bit b arrives (MSB first), the number n becomes 2n + b. Its remainder mod 5
depends only on the old remainder, so a 5-state machine is enough:

| r | b = 0 | b = 1 |
|---|-------|-------|
| 0 | 0 | 1 |
| 1 | 2 | 3 |
| 2 | 4 | 0 |
| 3 | 1 | 2 |
| 4 | 3 | 4 |

Five states fit in 3 flip-flops. `d5` is simply "state == 0".

### Watch out for
- Only update when `valid` is high.
- The empty number (after reset) is 0, which is divisible by 5.
