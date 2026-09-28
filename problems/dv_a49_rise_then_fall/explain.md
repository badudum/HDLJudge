### How it works

"A pulse between 2 and 4 cycles wide": after `$rose(a)`, a must stay high for at least 2 cycles and
fall within 4. One formulation:

```
$rose(a) |-> a[*2:4] ##1 !a
```

`a[*2:4]` means "a holds for 2 to 4 consecutive samples". If your simulator doesn't accept a
repetition range, split it into two properties: "still high 1 cycle later" and "low again within 2 to 4 cycles".

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- The rising cycle itself counts as the first high cycle.
