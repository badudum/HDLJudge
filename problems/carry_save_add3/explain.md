### How it works

A full adder compresses three bits of equal weight into a sum bit (weight 1) and a carry bit
(weight 2). Applying one per bit position turns three numbers into two, and no carry travels
sideways, so this layer is as fast as a single gate:

```
   a      10110101
   b      01101100
   c      11100011
  ─────────────────
 s=a^b^c  00111010
 cy=maj   11100101   (shifted left by one when added)
```

Then `a + b + c = s + (cy << 1)`, with one carry-propagate adder for the final result.

### Watch out for
- The final sum needs 10 bits (3 × 255 = 765).
