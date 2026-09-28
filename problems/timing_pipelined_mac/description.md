**Pipelining** is the main tool of timing closure: registers are placed inside a long
combinational path so that each clock period only covers part of it. It costs latency and a
few flip-flops, and buys clock frequency.

This unit computes `y = a·b + c·d` and must have a latency of **exactly two clock edges**,
producing a new result every cycle. The starter has the right latency and the right answer, but
it puts both register stages in the wrong places: one on the inputs and one on the output. Its
critical path runs through a multiplier *and* the final adder.

```
starter:   in ─▶[reg]─▶ (a·b + c·d) ─▶[reg]─▶ y       critical path = mul + add  (28)
target:    in ─▶ (a·b), (c·d) ─▶[reg]─▶ (+) ─▶[reg]─▶ y   critical path = mul   (≤ 24)
```

Move the registers so that no path exceeds **24 logic levels**.

### Interface

| Port        | Direction | Width |
|-------------|-----------|-------|
| `clk`       | input  | 1 |
| `a` `b` `c` `d` | input  | 8 (unsigned) |
| `y`         | output | 17 |
