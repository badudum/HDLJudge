The classic dual-clock FIFO (Cummings, SNUG 2002), and the standard way to move a stream of data
between unrelated clock domains.

```
         write domain                         read domain
wdata ─▶ [ 8 × 8 memory ] ──────────────────────▶ rdata
wptr(bin→gray) ─────────▶ [sync2] ─▶ empty logic
full logic ◀── [sync2] ◀──────────── rptr(bin→gray)
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `wclk` | input | 1 |
| `wrst` | input | 1 |
| `winc` | input | 1 |
| `wdata` | input | 8 |
| `wfull` | output | 1 |
| `rclk` | input | 1 |
| `rrst` | input | 1 |
| `rinc` | input | 1 |
| `rdata` | output | 8 |
| `rempty` | output | 1 |
