### How it works

The two core rules of every valid/ready (AXI-Stream style) channel:

1. `valid && !ready |=> valid`: a source may not withdraw an offer.
2. `valid && !ready |=> $stable(data)`: the offered payload is frozen until it's taken.

```
clk    _/‾\_/‾\_/‾\_/‾\_
valid  __/‾‾‾‾‾‾‾‾‾‾‾\__
ready  ________/‾‾‾\____
data   ==< D0      >===   stable until the transfer
```

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- After a transfer (`valid && ready`) both rules are released: valid may drop and data may change.
