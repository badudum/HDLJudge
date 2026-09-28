### How it works

Each clock has an enable that is synchronized to **its own** clock and changes only while that clock is low (a
negedge flop). Each branch waits until the other branch's enable has turned off before turning its own on:

```
sel ↑ → en0 drops at a falling clk0 edge (clk0 finishes its pulse)
      → en1 rises at a falling clk1 edge (clk1 starts cleanly)
clk_out = (clk0 & en0) | (clk1 & en1)
```

So `clk_out` only ever has full pulses, with a short low gap during the switch.

### Watch out for
- The cross-coupling uses the **final** enables, so both can never be high together.
- Switch requests must be spaced out: the circuit needs a few cycles of both clocks per switch.
