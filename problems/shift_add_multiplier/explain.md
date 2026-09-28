### How it works

Binary multiplication is a sum of shifted copies of the multiplicand, one per multiplier bit. For
**signed** operands the MSB of b weighs −2⁷, so its partial product is **subtracted**:

```
p = Σ(i=0..6) b[i]·(a << i)  −  b[7]·(a << 7)       (a sign-extended to 16 bits)
```

This is the same array a synthesizer builds for `*`: a two's-complement Baugh-Wooley-style adder array.

### Watch out for
- Sign-extend a to 16 bits before shifting.
- Check (−128) × (−128) = +16384.
