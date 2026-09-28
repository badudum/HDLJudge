### How it works

Every wire transition charges or discharges its capacitance. Bus-invert coding compares the next word with
what's currently on the bus. If more than half the wires would flip, it sends the inverted word instead, plus one
extra wire (`inv`) that tells the receiver to invert it back:

```
bus = 0000_0000, din = 1111_1110   (7 flips) → send 0000_0001, inv = 1   (1 + 1 flips)
```

At most N/2 data wires toggle per transfer.

### Watch out for
- Hamming distance = popcount(din ^ current bus).
- Exactly 4 flips: don't invert.
