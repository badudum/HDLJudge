Bring a signal from a slow clock domain into a fast one and detect its rising edges there.

```
d_slow ──▶[s1]──▶[s2]──┬──────────▶ q
            clk_fast   └─▶[s3]─┐
                        q & ~s3 ──▶ rise
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk_fast` | input | 1 |
| `rst` | input | 1 |
| `d_slow` | input | 1 |
| `q` | output | 1 |
| `rise` | output | 1 |
