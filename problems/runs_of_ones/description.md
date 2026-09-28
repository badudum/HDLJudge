Bit-parallel pattern matching: find runs and isolated ones in a single combinational step. It's the same idea as bitboard tricks in chess engines.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `x` | input | 16 |
| `run3` | output | 1 |
| `alone` | output | 16 |
