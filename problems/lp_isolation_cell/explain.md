### How it works

When a power domain is off, its outputs float. The always-on logic reading them could see any value, and
a floating input can even cause short-circuit current in the receiving gate. Isolation cells clamp each output to its
**inactive** level:

| signal type | clamp | cell |
|-------------|-------|------|
| data, active-high strobe | 0 | AND with ~iso_en |
| active-low request | 1 | OR with iso_en |

### Watch out for
- Clamping an active-low request to 0 would signal a request while the domain is off.
