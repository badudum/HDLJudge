A clock divider output `q` should toggle every **4** input clock cycles (a period of 8). Write the
assertion that verifies the toggle spacing:

```
q:  0000111100001111
      ^   ^   ^   ^    changes exactly 4 cycles apart
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `q` | input | 1 |
