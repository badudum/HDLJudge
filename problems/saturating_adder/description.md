In audio and DSP datapaths, wrap-around on overflow is a disaster: a loud positive sample
suddenly becomes a large negative one. **Saturating arithmetic** clamps the result to the
representable range instead.

Add two 8-bit **signed** numbers:

- if the exact sum fits in 8 bits, `sum` is the sum and `ovf = 0`;
- if it is larger than 127, `sum = 127` and `ovf = 1`;
- if it is smaller than −128, `sum = −128` and `ovf = 1`.

### Interface

| Port  | Direction | Width | Notes |
|-------|-----------|-------|-------|
| `a`   | input  | 8 | signed |
| `b`   | input  | 8 | signed |
| `sum` | output | 8 | signed, saturated |
| `ovf` | output | 1 | saturation happened |
