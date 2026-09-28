### How it works

A signal from another clock domain can change right at a sampling edge, and the first flop may go
**metastable**. A second flop gives it a full cycle to settle before anything uses the value. Slow-to-fast
crossings of a level are simple: the fast clock is guaranteed to see every level, because d_slow holds for many fast
cycles.

```
d_slow ─[s1]─[s2]─┬──────── q
                  └─[s3]─┐
             rise = s2 & ~s3
```

### Watch out for
- Never use `d_slow` or `s1` in logic.
- The edge detector works on the synchronized signal.
