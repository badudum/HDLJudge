### How it works

Two's-complement negation is "invert all bits, add 1". With the mask `m = {8{x[7]}}` (all ones for
negative x, all zeros otherwise):

- `x ^ m` inverts x only when it's negative;
- subtracting m (0 or −1) adds 1 only when it's negative.

So `(x ^ m) − m` equals `x` for x ≥ 0 and `−x` for x < 0, without any comparison or mux.

### Watch out for
- |−128| = 128 doesn't fit in a signed byte, but as an unsigned 8-bit result it is exactly 0x80,
  which is what the trick produces.
