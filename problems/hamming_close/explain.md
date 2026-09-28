### How it works

`d = a ^ b` has a 1 in every position where the words differ. "At most one difference" means d is
zero or a power of two, and the power-of-two test is the familiar `(d & (d − 1)) == 0`, which is
true for zero as well.

Hamming distance is the basis of error-correcting codes: a single-bit error moves a codeword to
distance 1, and SEC decoders look for exactly this.

### Watch out for
- Subtracting 1 from 0 wraps to all ones, but `0 & …` is still 0, so no special case is needed.
