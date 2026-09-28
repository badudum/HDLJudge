Design an 8-input **priority encoder**: `idx` is the index of the highest-numbered bit of
`req` that is set, and `valid` says whether any bit is set at all.

| `req`       | `idx` | `valid` |
|-------------|-------|---------|
| `0000_0000` | 0     | 0 |
| `0000_0001` | 0     | 1 |
| `0010_1100` | 5     | 1 |
| `1xxx_xxxx` | 7     | 1 |

Priority encoders turn interrupt lines into an interrupt number, pick the winner in fixed-priority
arbiters, and appear inside floating-point normalizers.

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `req`   | input  | 8 |
| `idx`   | output | 3 |
| `valid` | output | 1 |
