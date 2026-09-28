Mechanical buttons **bounce**: for a few milliseconds after a press, the contact opens and
closes many times. Counting those bounces as presses is a classic embedded bug.

Build a debouncer: `clean` follows `btn`, but only once `btn` has held a *new* value for
**4 consecutive clock edges**.

```
btn   : 0 1 1 0 1 1 1 1 1 1 0 1 0 0 0 0 0
clean : 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0
                      ^ 4th consecutive 1         ^ 4th consecutive 0
```

(Each column is one clock cycle. `clean` changes right after the edge that samples the 4th
consecutive differing value.)

### Interface

| Port  | Direction | Width |
|-------|-----------|-------|
| `clk` | input  | 1 |
| `rst` | input  | 1 (synchronous, active high) |
| `btn` | input  | 1 (noisy) |
| `clean` | output | 1 (debounced) |
