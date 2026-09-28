A **non-blocking cache** keeps serving hits while misses are outstanding. It records each
outstanding miss in a **Miss Status Holding Register** (MSHR). A later miss to a line that's
already being fetched is **merged** instead of sending a duplicate request to memory.

```
miss 0x40   → primary:   MSHR0 = 0x40, request memory
miss 0x80   → primary:   MSHR1 = 0x80, request memory
miss 0x40   → secondary: merge into MSHR0 (no request)
resp id 0   → MSHR0 free again
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `miss_valid`, `resp_valid` | input | 1 |
| `miss_addr` | input | 8 |
| `resp_id` | input | 2 |
| `mem_req`, `merged`, `stall` | output | 1 |
| `mem_id`, `merge_id` | output | 2 |
| `mem_addr` | output | 8 |
| `valid_mask` | output | 4 |
