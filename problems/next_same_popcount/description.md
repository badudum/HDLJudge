Enumerate all k-subsets of a set in order? In software that's *Gosper's hack*, a famous
bit-manipulation puzzle. Build it as a single combinational block.

```
0b0011_1000 → 0b0100_0011
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `x` | input | 16 |
| `nxt` | output | 16 |
