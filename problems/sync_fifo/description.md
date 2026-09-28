Design a **synchronous FIFO** that stores up to **8 entries of 8 bits**.

Everything happens on the rising edge of `clk`:

- **Write:** if `wr_en = 1` and the FIFO is **not full**, `din` is pushed. A write while full is ignored.
- **Read:** if `rd_en = 1` and the FIFO is **not empty**, the oldest entry is popped and appears on
  `dout` right after that edge (`dout` is registered). A read while empty is ignored and `dout`
  keeps its previous value. `dout` also keeps its value in cycles without a read.
- A read and a write in the same cycle are both performed when allowed by the rules above
  (full / empty are evaluated **before** the edge). For example, with a full FIFO and both
  `wr_en` and `rd_en` high, only the read happens.

Status outputs describe the FIFO contents **after** the most recent edge:

| Output  | Meaning |
|---------|---------|
| `count` | number of stored entries, 0 – 8 |
| `empty` | `1` when `count == 0` |
| `full`  | `1` when `count == 8` |

### Reset

`rst` is synchronous and active high: the FIFO becomes empty and `dout` becomes `0`.

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `clk`   | input  | 1 |
| `rst`   | input  | 1 |
| `wr_en` | input  | 1 |
| `din`   | input  | 8 |
| `rd_en` | input  | 1 |
| `dout`  | output | 8 |
| `full`  | output | 1 |
| `empty` | output | 1 |
| `count` | output | 4 |
