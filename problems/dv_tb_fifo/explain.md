### How it works

A FIFO's bugs hide at the boundaries, so a good testbench combines:

1. a **queue-based model** (`push_back` on accepted writes, `pop_front` on accepted reads) and checks of
   `dout`, `count`, `full` and `empty` every cycle;
2. **directed boundary tests**: write while full, read while empty, simultaneous read and write when full
   and when empty, reset mid-stream;
3. **long random traffic**, biased toward the full and empty states, to reach wrap-around bugs.

### Watch out for
- The model must use the same acceptance rules as the spec (a write while full is ignored).
- Compare before driving the next inputs (at the falling edge) to avoid races.
