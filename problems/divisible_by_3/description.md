A number arrives **one bit per clock, most significant bit first**, starting from 0 after reset.
After each bit, report whether the number received so far is **divisible by 3**.

```
din :    1    1    0    1    1
value:   1    3    6    13   27
div :    0    1    1    0    1
```

The stream can be arbitrarily long (thousands of bits), so storing the number is not an
option. Division and modulo operators are banned. This is a finite-state-machine puzzle.

### Interface

| Port  | Direction | Width |
|-------|-----------|-------|
| `clk` | input  | 1 |
| `rst` | input  | 1 (synchronous, active high) |
| `din` | input  | 1 |
| `div` | output | 1 |
