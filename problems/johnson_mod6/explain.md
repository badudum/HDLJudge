### How it works

A Johnson counter is a shift register whose inverted output feeds back into its input. With n
flip-flops it visits 2n states, each differing from the next in exactly one bit:

```
000 → 001 → 011 → 111 → 110 → 100 → (000)
```

Each state can be recognized by looking at just **two adjacent bits**, so decoding is one 2-input
gate per state. Because only one bit changes per step, the decoded outputs are glitch-free, which
makes Johnson counters popular for clock division and multi-phase clock generation.

### Watch out for
- A Johnson counter must start in a legal state. Illegal patterns such as 010 form a separate
  cycle, so the reset is essential.
