### How it works

Each set holds two lines, and an LRU bit per set says which to evict. With **write-back**, a write only updates the
cache and marks the line dirty. The memory is updated only when a dirty line is evicted:

```
miss → victim = invalid way, else LRU way
       victim dirty? → write it back (wb_valid, wb_addr, wb_data)
       refill: mem_rdata (read) or wdata (write, dirty)
```

Write-back saves bandwidth when the same line is written many times.

### Watch out for
- The written-back address is `{victim tag, set}`, not the current address.
- A hit and a refill both make that way MRU.
