**SIMD** (single instruction, multiple data) units apply one operation to several packed
elements at once: MMX/SSE, NEON, and every GPU lane-group. The key hardware detail is
**cutting the carry chain** at lane boundaries.

A 32-bit operand is split into lanes:

```
mode 0 (4 × 8):   [ lane3 | lane2 | lane1 | lane0 ]
mode 1 (2 × 16):  [    lane1      |    lane0      ]
```

| `op` | Per-lane operation (unsigned) |
|------|-------------------------------|
| 00 | `a + b` (wraps within the lane) |
| 01 | `a - b` (wraps within the lane) |
| 10 | `a + b`, saturating at the lane maximum (0xFF / 0xFFFF) |
| 11 | `max(a, b)` |

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `a`, `b` | input | 32 |
| `mode` | input | 1 |
| `op` | input | 2 |
| `y` | output | 32 |
