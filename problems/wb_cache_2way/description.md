A write-back, write-allocate, 2-way set-associative cache with true LRU replacement. Dirty lines
are written back to memory only when they are evicted, which is what saves the bandwidth.

```
addr[5:2] tag | addr[1:0] set        set s:  [way0: v d tag data] [way1: v d tag data] lru
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `we` | input | 1 |
| `addr` | input | 6 |
| `wdata` | input | 8 |
| `mem_rdata` | input | 8 |
| `hit` | output | 1 |
| `rdata` | output | 8 |
| `wb_valid` | output | 1 |
| `wb_addr` | output | 6 |
| `wb_data` | output | 8 |
