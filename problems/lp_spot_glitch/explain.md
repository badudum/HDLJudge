### How it works

An AND gate on a clock is only safe if its other input can't change while the clock is high. When `en`
rises in the middle of a high phase, the AND output rises too, producing a runt pulse that clocks the counter.
When `en` falls mid-phase, a pulse is chopped short. Look at the waveform around every `en` change that happens while
`clk` is high.

### Watch out for
- The fix is the standard clock-gating structure: see *Latch-Based Clock Gate*.
