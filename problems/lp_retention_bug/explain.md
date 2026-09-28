### How to debug it

1. Submit the starter as-is and read the **first** failing check: its name tells you which behaviour is broken.
2. Open the **Waveform** tab and find the first cycle where an output differs from the expected value. The bug is in
   the logic that produced that value, one clock earlier for registered outputs.
3. Fix one bug at a time and resubmit. Once the first check passes, the next failure often points at the second bug.

### Watch out for
- Power-down and power-up are *sequences*. Check what the shadow register holds at each step, and what the
  always-on side sees while the domain is off.
- Pay attention to the priority between `restore` and normal operation in the first cycle after power-up.
