### How to debug it

1. Submit the starter as-is and read the **first** failing check: its name tells you which behaviour is broken.
2. Open the **Waveform** tab and find the first cycle where an output differs from the expected value. The bug is in
   the logic that produced that value, one clock earlier for registered outputs.
3. Fix one bug at a time and resubmit. Once the first check passes, the next failure often points at the second bug.

### Watch out for
- One of the bugs makes simulation disagree with synthesis: look for a combinational block whose sensitivity or
  assignments don't describe pure combinational logic.
- Overlapping detection: after a match, the FSM must continue from the right state.
