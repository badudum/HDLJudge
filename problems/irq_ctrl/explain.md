### How it works

The controller turns edges on eight interrupt lines into sticky **pending** bits, masks them, and
presents the highest-priority enabled one to the CPU:

```
pending |= irq_in & ~irq_prev          (edge detect)
irq      = |(pending & mask)
id       = lowest set bit of pending & mask
ack      → clear pending[id]
```

### Watch out for
- Masked sources still latch their edges.
- If the acknowledged source has a new edge on the same clock, set wins.
