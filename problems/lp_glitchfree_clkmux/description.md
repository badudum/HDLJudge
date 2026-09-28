Switching between two clocks with a plain mux (`sel ? clk1 : clk0`) can produce a runt pulse that
clocks some flops and not others. Build the classic glitch-free clock multiplexer, used in every
SoC for switching between a PLL and a crystal.

```
clk0 ─┬──────────────────────(AND)──┐
      └─▶ sync ─▶ negedge ─▶ en0 ─┘   ├─(OR)─ clk_out
clk1 ─┬──────────────────────(AND)──┘
      └─▶ sync ─▶ negedge ─▶ en1 ─┘
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk0` | input | 1 |
| `clk1` | input | 1 |
| `rst` | input | 1 |
| `sel` | input | 1 |
| `clk_out` | output | 1 |
