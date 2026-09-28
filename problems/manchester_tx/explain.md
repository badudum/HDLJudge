### How it works

Each data bit becomes two half-bits with a transition in the middle:

```
bit 1 → low, high  (rising mid-bit transition)
bit 0 → high, low  (falling mid-bit transition)
```

A counter k runs over the 16 half-bits: bit = `data[7 − k/2]`, first half = ~bit, second half = bit.
Since every bit period contains a transition, the receiver can recover the clock from the data, and the
signal has no DC component, which suits transformer-coupled links.

### Watch out for
- `tx` is registered: the first half-bit appears right after the `load` edge.
- Return to idle (`tx = 0`, `busy = 0`) one edge after the 16th half-bit.
