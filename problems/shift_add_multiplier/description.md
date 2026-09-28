Multiply two signed bytes without the `*` operator. You'll build the shift-and-add array a synthesizer would otherwise generate for you, and handle the sign bit correctly.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `a` | input | 8 |
| `b` | input | 8 |
| `p` | output | 16 |
