### How it works

A checkerboard gives every cell the opposite value of its neighbours, so a short between adjacent cells
(a coupling or bridging fault) shows up as a read mismatch. The inverse pass then tests every cell in the other
polarity, which catches stuck-at-0 and stuck-at-1 cells.

```
row\col  0    1    2    3
   0     55   AA   55   AA
   1     AA   55   AA   55
```

### Watch out for
- Registered outputs describe the operation of the **current** cycle, and the comparison uses `mem_rdata` in that same cycle.
- `fail` is sticky until the next `start`.
