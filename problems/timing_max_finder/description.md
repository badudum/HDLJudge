Find the **largest of eight 8-bit values** and its position, within a tight timing budget.

The starter code scans the list linearly: 7 compare-and-select stages in series, about
84 gate levels. Reorganize the comparisons as a **tournament tree** so that the critical
path fits in **40 levels**, without changing the tie-breaking rule.

```
linear:  m = x0; m = max(m, x1); m = max(m, x2); … ; m = max(m, x7)    7 stages
tree:    max(max(max(x0,x1), max(x2,x3)), max(max(x4,x5), max(x6,x7)))  3 stages
```

### Interface

| Port  | Direction | Width | Notes |
|-------|-----------|-------|-------|
| `x`   | input  | 64 | eight packed unsigned bytes, element i = `x[8i+7:8i]` |
| `max` | output | 8  | largest element |
| `idx` | output | 3  | its index (lowest on ties) |
