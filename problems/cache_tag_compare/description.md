The core of every set-associative cache lookup: compare the requested address tag against
the tags stored in all ways of the selected set **in parallel**.

```
                 ┌── way 0: valid, tag0 ─┐
address tag ─────┼── way 1: valid, tag1 ─┼──▶ hit, hit_way, hit_onehot, multi_hit
                 ├── way 2: valid, tag2 ─┤
                 └── way 3: valid, tag3 ─┘
```

The one-hot form drives the data-array output mux, and the encoded form goes to the
replacement logic. `multi_hit` flags an illegal state (two valid ways holding the same tag),
which real designs report as a machine-check error.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `tag` | input | 20 |
| `way_tags` | input | 80 (way i at `[20i+19:20i]`) |
| `way_valid` | input | 4 |
| `hit`, `multi_hit` | output | 1 |
| `hit_way` | output | 2 |
| `hit_onehot` | output | 4 |
