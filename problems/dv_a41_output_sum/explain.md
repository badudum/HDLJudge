### How it works

An **end-to-end data check**: the output this cycle must equal the function of the inputs one
cycle ago:

```
y == $past(a) + $past(b)
```

Extend to 9 bits so the carry isn't lost (`9'($past(a)) + $past(b)`). This style of assertion
works as a built-in scoreboard for simple pipelines.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Skip the first cycle after reset, when `$past` still refers to values from inside reset.
