### How it works

- Width 1: `strobe |=> !strobe`.
- Gap ≥ 2: when the strobe has just fallen (`$fell(strobe)`, i.e. low now and high before), it must
  also be low in the next cycle: `$fell(strobe) |=> !strobe`.

Together: pulses are exactly one cycle wide and separated by at least two low cycles.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `$fell` compares with the previous sample, so it's true in the first low cycle.
