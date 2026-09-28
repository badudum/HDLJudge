### How it works

Powers of four are the powers of two whose single 1 sits at an **even** bit index
(1 = bit 0, 4 = bit 2, 16 = bit 4, …). So the test has two parts:

1. **Exactly one bit set:** `x != 0 && (x & (x − 1)) == 0`. Subtracting 1 clears the lowest set
   bit, so nothing remains exactly when there was only one.
2. **At an even position:** `x & 16'h5555` is non-zero (0x5555 = 0101…0101).

### Watch out for
- `x = 0` passes `(x & (x − 1)) == 0` and must be excluded explicitly.
- `x & (x − 1)` needs 16-bit arithmetic: size the literal (`16'd1`).
