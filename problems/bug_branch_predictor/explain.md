### How it works

Train a single branch and watch its counter step by step. A 2-bit saturating counter has a
defined behaviour at both ends (it saturates) and a defined prediction rule (the upper bit). Check each rule against
the waveform, and especially what happens after four updates in the same direction.

### Watch out for
- Keep the table organization: the fix is small.
- Aliasing (two branches sharing an entry) is expected, not a bug.
