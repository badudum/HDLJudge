### How it works

Changing a divider's ratio in the middle of a period produces a truncated pulse, and downstream flops would
see a clock period shorter than they were timed for. Applying the new ratio only at the start of a period
(where the output rises) keeps every high and low phase a whole number of half-periods of the ratio in effect:

```
div:     0 0 0 1 1 1 1 1
clk_out: ‾|_|‾|_ ‾‾|__|‾‾|__      new ratio from the next rising edge only
```

### Watch out for
- Load the ratio at the edge where `clk_out` goes 0 → 1, and use it for both halves of that period.
