True LRU for 8 ways needs a full recency order (8! states). **Tree pseudo-LRU** gets close
with just **7 bits**: a binary tree where each node points toward the half that was used
*less* recently.

```
                  b0
            /            \
          b1              b2
        /    \          /    \
      b3      b4      b5      b6
     /  \    /  \    /  \    /  \
    w0  w1  w2  w3  w4  w5  w6  w7
```

- **Find the victim:** start at `b0`. Bit 0 → go left, bit 1 → go right.
- **On an access to way w:** flip the nodes on w's path to point *away* from w.

After reset all bits are 0, so the victim is way 0.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `touch` | input | 1 |
| `way` | input | 3 |
| `victim` | output | 3 |
| `bits` | output | 7 (`bits[0]` = root, heap order) |
