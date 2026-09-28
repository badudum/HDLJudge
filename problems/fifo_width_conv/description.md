Bus width converters join narrow and wide streams (e.g. an 8-bit UART stream into a 32-bit DMA). Build the upsizer with proper valid/ready flow control on both sides.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `in_valid` | input | 1 |
| `in_data` | input | 8 |
| `in_ready` | output | 1 |
| `out_valid` | output | 1 |
| `out_data` | output | 32 |
| `out_ready` | input | 1 |
