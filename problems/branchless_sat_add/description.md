Saturating arithmetic (used in DSP and pixel processing) clamps instead of wrapping. Without a mux, the carry itself becomes the clamp.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `a` | input | 8 |
| `b` | input | 8 |
| `y` | output | 8 |
