### How it works

Power gating destroys the contents of every flip-flop in the domain. A retention register adds
an always-on shadow latch:

```
save    : shadow ← q        (before power-down, while still powered)
pwr off : q is lost          (modelled as 0 here)
restore : q ← shadow         (after power-up, before normal operation)
```

The power controller sequences these signals (see *Power Sequencer FSM*). Outputs of a domain that is off are
isolated to 0.

### Watch out for
- The shadow keeps its value while power is off, and only `save` changes it.
- Priority for q: power off > restore > enable.
