In a **Gray code**, consecutive values differ in exactly one bit. That's why Gray counters
are used to pass pointers safely between clock domains (asynchronous FIFOs) and in
rotary encoders.

Build both directions of the conversion as one combinational module:

- `gray` is the Gray encoding of `bin`;
- `bin_out` is the binary value whose Gray encoding is `gray_in`.

| Decimal | Binary | Gray |
|---------|--------|------|
| 0 | 000 | 000 |
| 1 | 001 | 001 |
| 2 | 010 | 011 |
| 3 | 011 | 010 |
| 4 | 100 | 110 |

### Interface

| Port      | Direction | Width |
|-----------|-----------|-------|
| `bin`     | input  | 8 |
| `gray_in` | input  | 8 |
| `gray`    | output | 8 |
| `bin_out` | output | 8 |
