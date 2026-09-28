A 16-word single-port RAM with a registered (synchronous) read port and **write-first**
read-during-write behavior:

```
edge:   1                 2
en/we:  1/1 addr=3 0x5A   1/0 addr=3
rdata:  → 0x5A            → 0x5A
```

The firmware team reports that the upper half of the memory mirrors the lower half, and that
a read issued together with a write returns stale data. **2 bugs**.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `en`, `we` | input | 1 |
| `addr` | input | 4 |
| `wdata` | input | 8 |
| `rdata` | output | 8 |
