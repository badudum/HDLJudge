An equality comparator is an XOR per bit followed by a NOR tree. Build it from the gates themselves.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `a` | input | 16 |
| `b` | input | 16 |
| `eq` | output | 1 |
| `diff_mask` | output | 16 |
