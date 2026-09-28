A skid buffer that was 'optimized' during a code review. It now loses and reorders words under
backpressure, but only when the output stalls in specific patterns.

**2 bugs** are hidden in the code.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `in_valid` | input | 1 |
| `in_data` | input | 8 |
| `in_ready` | output | 1 |
| `out_valid` | output | 1 |
| `out_data` | output | 8 |
| `out_ready` | input | 1 |
