### How it works

A 2-way cache normally reads both ways' tags (and data) every access. Way prediction reads only the
way predicted by the MRU bit. If it hits, the access costs half the energy. On a mispredict the other way is
read in a second step. Since most accesses hit the MRU way, the average energy approaches that of a
direct-mapped cache.

```
predicted hit  → fast_hit, 1 tag read
other way hits → slow_hit, 2 tag reads
neither        → miss, 2 tag reads, fill
```

### Watch out for
- After every access, the way that hit (or was filled) becomes MRU.
- Fill an invalid way first (way 0 before way 1).
