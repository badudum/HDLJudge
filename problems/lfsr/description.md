Implement an 8-bit **Fibonacci linear-feedback shift register** — the workhorse of
pseudo-random bit sequences (PRBS), scramblers and built-in self test.

On every rising edge of `clk`:

1. `rst = 1` → `q` becomes `8'h01` (the all-zero state would lock up the LFSR);
2. else `load = 1` → `q` becomes `seed`;
3. else `en = 1` → shift left, inserting the feedback bit
   `fb = q[7] ^ q[5] ^ q[4] ^ q[3]` at bit 0: `q <= {q[6:0], fb}`;
4. otherwise `q` holds.

### Interface

| Port   | Direction | Width |
|--------|-----------|-------|
| `clk`  | input  | 1 |
| `rst`  | input  | 1 (synchronous, active high) |
| `load` | input  | 1 |
| `seed` | input  | 8 |
| `en`   | input  | 1 |
| `q`    | output | 8 |
