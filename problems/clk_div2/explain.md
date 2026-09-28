### How it works

A toggle flip-flop (`q <= ~q`) halves the frequency with an exact 50 % duty cycle. The divided clock
must come **straight from the flop**: any gate after it could glitch, and a glitch on a clock is a
false edge for every flop it drives.

### Watch out for
- Use exactly one flip-flop.
- In a real flow you would declare it with `create_generated_clock` in the timing constraints.
