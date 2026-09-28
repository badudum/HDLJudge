The read side of a classic asynchronous FIFO (Cummings style): a binary pointer for addressing
memory, and a Gray-coded copy that is safe to send across clock domains.

```
rd_bin:  0000 0001 0010 0011 0100 …
rd_gray: 0000 0001 0011 0010 0110 …
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `rd_en` | input | 1 |
| `wr_gray_sync` | input | 4 |
| `rd_gray` | output | 4 |
| `rd_addr` | output | 3 |
| `empty` | output | 1 |
