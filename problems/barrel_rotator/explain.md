### How it works

A barrel rotator is log₂(width) stages of 2:1 muxes. Stage k rotates by 2ᵏ positions when bit k of
the amount is set:

```
din ─[rot 1 if amt[0]]─[rot 2 if amt[1]]─[rot 4 if amt[2]]─ dout
```

Three stages of muxes, compared with 8 alternatives in one big mux. A rotation is a shift where the bits leaving one
end re-enter at the other: `{din[6:0], din[7]}` rotates left by one.

### Watch out for
- Right rotation is left rotation by (8 − amt).
