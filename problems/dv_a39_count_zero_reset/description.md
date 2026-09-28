The simplest reset check of all: one cycle after reset is asserted, the counter under test must
read **zero**. Many real bugs come from a missing reset branch or a mis-wired reset polarity.

Write an assertion that fails if `count` is not 0 in the cycle following a cycle with `rst = 1`.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `count` | input | 4 |
