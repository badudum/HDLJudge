Out-of-order CPUs remove false dependencies (WAR, WAW) by **renaming** architectural
registers to a larger pool of physical registers. Two structures do the work:

- the **RAT** (register alias table), holding the current physical register for each
  architectural register;
- the **free list**, a FIFO of unused physical registers.

For each instruction: read the sources' current mappings, grab a fresh physical register for
the destination, and remember the old one (freed later, when the instruction commits).

```
reset:   RAT = [0 1 2 3 4 5 6 7]    free = 8 9 10 … 15
add r3, r1, r2  → ps1=1  ps2=2  pd=8  old_pd=3   RAT[3]=8
sub r4, r3, r3  → ps1=8  ps2=8  pd=9  old_pd=4   RAT[4]=9
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `ren_valid`, `has_rd`, `free_valid` | input | 1 |
| `rs1`, `rs2`, `rd` | input | 3 |
| `free_preg` | input | 4 |
| `ren_ok`, `stall` | output | 1 |
| `ps1`, `ps2`, `pd`, `old_pd` | output | 4 |
