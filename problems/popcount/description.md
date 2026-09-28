Count the number of `1` bits in a 16-bit word (the *Hamming weight*). Population count shows up
in error-correction decoders, bit-vector databases and neural-network accelerators.

The result must be available combinationally. `$countones` is off-limits: build the adder
structure yourself.

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `x`     | input  | 16 |
| `count` | output | 5 |
