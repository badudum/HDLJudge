### How to debug it

1. Submit the starter as-is and read the **first** failing check: its name tells you which behaviour is broken.
2. Open the **Waveform** tab and find the first cycle where an output differs from the expected value. The bug is in
   the logic that produced that value, one clock earlier for registered outputs.
3. Fix one bug at a time and resubmit. Once the first check passes, the next failure often points at the second bug.

### Watch out for
- The specified read mode is **write-first**: a read of the address being written returns the new data.
- With `en = 0`, nothing may change, including `rdata`.
