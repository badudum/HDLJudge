### How it works

1. **Which is smaller?** Compute `d = a − b` with both operands sign-extended to 9 bits. The result
   can't overflow, so `d[8]` is 1 exactly when a < b.
2. **Mask:** replicate that bit, `m = {8{d[8]}}`: all ones when a < b, otherwise all zeros.
3. **Select with XOR:** `b ^ ((a ^ b) & m)` is a when m is all ones (b ^ a ^ b = a) and b otherwise.

This is the classic branchless min/max from software bit hacks. In hardware it replaces a
comparator + mux with a subtractor + AND/XOR.

### Watch out for
- In 8 bits, 127 − (−128) overflows. That's why the subtraction must be 9 bits wide.
