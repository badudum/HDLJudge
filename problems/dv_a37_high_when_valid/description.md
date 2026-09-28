**Checker problems** turn the tables: instead of a design, you write the **assertions** that
catch a bad design. The hidden testbench replays several recorded signal traces into your
checker module, some legal and some containing a protocol violation. Your checker must fail on
exactly the violating traces.

Write a checker for this rule:

> Whenever `valid` is high, `en` must also be high (sampled at each rising edge of `clk`,
> ignored while `rst` is high).

```
clk   _/‾\_/‾\_/‾\_/‾\_/‾\_
valid ____/‾‾‾‾‾‾‾‾‾\_____
en    ____/‾‾‾‾‾\_________
                  ^ violation: valid = 1, en = 0
```

Use SystemVerilog Assertions (`assert property`). They run on Verilator. Plain procedural
checks with `$error` also work.

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `clk`   | input | 1 |
| `rst`   | input | 1 (active high) |
| `valid` | input | 1 |
| `en`    | input | 1 |
