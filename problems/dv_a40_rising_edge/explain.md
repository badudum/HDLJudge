### How it works

An edge detector has a two-way contract: every rising edge produces a pulse, and a pulse only
appears on a rising edge. So write two implications:

- `$rose(a) |-> pulse`
- `pulse |-> $rose(a)`

(or one equivalence: `pulse == $rose(a)`).

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- Check both directions: a detector that is stuck at 1 satisfies the first rule alone.
