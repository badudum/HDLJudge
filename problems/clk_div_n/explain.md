### How it works

A counter from 0 to N−1 sets the period. The output is high while the counter is in the first ⌊N/2⌋
states. Registering the output (rather than decoding the counter combinationally) guarantees a
glitch-free clock whose edges line up with the input clock's rising edges.

| N | high | low |
|---|------|-----|
| 4 | 2 | 2 |
| 5 | 2 | 3 |
| 7 | 3 | 4 |

### Watch out for
- N = 2 must work too (a 1-bit counter).
- An exact 50 % duty for odd N needs the falling edge: see *Clock Divide by 3*.
