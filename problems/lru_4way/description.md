When a cache set is full and a new line arrives, the **replacement policy** picks the victim.
True **LRU** evicts the way that was used least recently. It is the ideal policy, but it has to
track a full recency order.

Implement exact LRU for one 4-way set:

```
reset:              order (LRU → MRU) = 0 1 2 3     victim = 0
access way 2:       order = 0 1 3 2                 victim = 0
access way 0:       order = 1 3 2 0                 victim = 1
access way 1:       order = 3 2 0 1                 victim = 3
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst` | input | 1 (synchronous, active-high reset) |
| `touch` | input | 1 (the set is accessed this cycle) |
| `way` | input | 2 |
| `victim` | output | 2 |
