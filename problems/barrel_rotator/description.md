Build an 8-bit **barrel rotator**: in a single combinational step, rotate `din` by `amt`
positions (0 – 7), to the left when `dir = 0` and to the right when `dir = 1`.

```
din           = 1000_0011
rotate left 1 = 0000_0111
rotate right 2= 1110_0000
```

Rotators are used in cryptography (e.g. ChaCha, SHA-2), in CRC hardware and inside
general-purpose barrel shifters.

### Interface

| Port   | Direction | Width |
|--------|-----------|-------|
| `din`  | input  | 8 |
| `amt`  | input  | 3 |
| `dir`  | input  | 1 |
| `dout` | output | 8 |
