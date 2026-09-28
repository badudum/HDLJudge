### How it works

Keep two pieces of history in auxiliary flags:

- `saved`: set by `save` while isolated, cleared when isolation ends;
- `restored`: set by `restore` while powered, cleared when power drops.

Then assert on the **events**:

- `$fell(pwr_en) |-> iso_en && $past(iso_en) && saved`;
- `$fell(iso_en) |-> pwr_en && $past(pwr_en) && restored`.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- These are the checks that UPF-aware simulators insert automatically. Writing them by hand shows what they mean.
