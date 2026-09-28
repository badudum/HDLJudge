### How it works

Insertion into a sorted list of three, in one cycle: compare the new value with all three entries in
parallel. The first entry it beats is where it goes, everything below shifts down, and the smallest drops
out.

```
t0 ≥ t1 ≥ t2,   din > t1 but not > t0   →   t2 ← t1, t1 ← din
```

### Watch out for
- Duplicates count separately: 9, 9, 7 is a valid top-3.
- Only `valid` samples are inserted.
