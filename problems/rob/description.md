Out-of-order processors execute instructions whenever their operands are ready, but they
must **retire** them in program order (precise exceptions, correct architectural state).
The **reorder buffer** makes that possible: a circular queue with an entry per in-flight
instruction.

```
         head                     tail
          ↓                         ↓
 [ I0 done | I1 wait | I2 done | … ]
 commit I0 now; I2 must wait for I1 even though it finished.
```

Per edge (all using the pre-edge state):

1. **Commit** the head entry if it is done.
2. **Complete**: mark the entry `complete_tag` done and store its result.
3. **Allocate** a new entry at the tail, unless the ROB is full.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `alloc_valid`, `complete_valid` | input | 1 |
| `alloc_rd` | input | 5 |
| `complete_tag` | input | 3 |
| `complete_data` | input | 16 |
| `alloc_ok`, `commit_valid` | output | 1 |
| `alloc_tag` | output | 3 |
| `commit_rd` | output | 5 |
| `commit_data` | output | 16 |
| `count` | output | 4 |
