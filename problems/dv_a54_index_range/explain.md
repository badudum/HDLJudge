### How it works

- Range: `(we || re) |-> addr < 12`. A 4-bit address can express 12 … 15, but the memory has only 12 entries.
- Exclusivity: `!(we && re)`.

Out-of-range indices are the hardware equivalent of buffer overflows. In simulation they read X or
alias to other entries, so this assertion catches them early.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- `addr` is don't-care when neither strobe is active.
