### How it works

Logic BIST applies pseudo-random patterns generated on-chip. The LFSR steps through all 65535
non-zero states. Neighbouring LFSR bits are just time-shifted copies of each other, so a **phase shifter**
XORs taps together to give each scan chain a decorrelated sequence.

```
state:  … s15 s14 … s1 s0 ← fb = s15 ^ s13 ^ s12 ^ s10
chain0 = s0 ^ s5,  chain1 = s3 ^ s9,  …
```

### Watch out for
- `load` has priority over `en`.
- Never load 0: a zero LFSR stays zero.
