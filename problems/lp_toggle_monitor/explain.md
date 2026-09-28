### How it works

Dynamic power is roughly C·V²·f·α, where α is the switching activity. Counting toggles, per bit and per
cycle, gives a cheap on-chip estimate of α. Power governors use such monitors to throttle or change voltage and
frequency, and verification uses them to find power hot spots.

```
toggles(this edge) = popcount(bus ^ prev)
```

### Watch out for
- The value latched at the end of a window must include that edge's toggles.
- `prev` resets to 0, so the first edge counts the bits set in `bus`.
