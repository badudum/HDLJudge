### How it works

Keep the last 8 samples in a shift register. On each valid sample, compute the min and max of the
**new** window (the incoming sample plus the 7 newest stored ones) with two comparator trees, and register
them.

A running max can't simply be updated incrementally: when the current maximum leaves the window,
the new maximum is some other element, so all of them have to be looked at again. The tree does that
in log₂ 8 = 3 comparator levels.

### Watch out for
- After reset the window is full of zeros, so `wmin` stays 0 until 8 samples have arrived.
- Without `valid`, nothing changes.
