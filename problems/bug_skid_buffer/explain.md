### How it works

Trace one word through the buffer by hand under backpressure. A skid buffer has only two places a word
can be (main register and skid register), and one invariant: the skid entry is always **older** than
anything still on the input. Throttle `out_ready` in short patterns, and check that every accepted word
comes out exactly once and in order.

### Watch out for
- Watch what happens to the skid register when a word arrives while `in_ready` is 0.
- Keep the architecture: the fix is small.
