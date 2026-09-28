The smallest real cache: direct-mapped, write-through, no write-allocate. An external controller
issues fills after misses, and the cache reports hits and keeps hit/miss statistics.

```
addr[7:3] tag | addr[2:0] index
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `rd` | input | 1 |
| `wr` | input | 1 |
| `fill` | input | 1 |
| `inv` | input | 1 |
| `addr` | input | 8 |
| `wdata` | input | 8 |
| `fill_data` | input | 8 |
| `hit` | output | 1 |
| `rdata` | output | 8 |
| `hits` | output | 8 |
| `misses` | output | 8 |
