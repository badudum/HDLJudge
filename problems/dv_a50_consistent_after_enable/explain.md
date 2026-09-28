### How it works

While `en` stays high, `data` must not change from one cycle to the next:

```
en && $past(en) |-> $stable(data)
```

The `$past(en)` term excludes the cycle in which `en` rises, when new data is allowed.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `$stable(data)` compares with the previous sample.
