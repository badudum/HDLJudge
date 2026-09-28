### How it works

Booth's algorithm scans the multiplier's bit pairs {Q[0], Q₋₁}:

| pair | action |
|------|--------|
| 00, 11 | nothing (inside a run) |
| 01 | A += M (end of a run of ones) |
| 10 | A −= M (start of a run of ones) |

Then {A, Q, Q₋₁} shifts right arithmetically. After 8 steps, {A, Q} holds the signed product.
Runs of ones cost one subtraction and one addition regardless of their length, and negative multipliers need
no correction.

### Watch out for
- The shift is **arithmetic**: replicate A's sign bit.
- Use a 9-bit accumulator (or be careful with −128) to avoid overflow in A − M.
