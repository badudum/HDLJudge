Implement a 16-bit **count-leading-zeros** (CLZ) unit: `n` is the number of consecutive `0`
bits starting from the MSB of `x`.

| `x`                   | `n` |
|-----------------------|-----|
| `1000_0000_0000_0000` | 0   |
| `0001_0110_0000_0000` | 3   |
| `0000_0000_0000_0001` | 15  |
| `0000_0000_0000_0000` | 16  |

CLZ is the heart of floating-point normalization and of fast integer `log2`.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `x`  | input  | 16 |
| `n`  | output | 5 |
