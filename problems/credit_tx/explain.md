### How it works

Credit-based flow control replaces the ready signal with a counter. The sender starts with as many
credits as the receiver has buffer slots. Each word sent consumes one credit, and the receiver returns a
credit each time it frees a slot. As long as `credits > 0`, a word can be sent without asking.

```
credits:  4 → 3 → 2 → 1 → 0 (stall) → 1 (credit returned) → 0 …
```

Because the sender never needs the receiver's ready in the same cycle, the link can be pipelined over
many cycles. This is how PCIe, NoCs and chip-to-chip links work.

### Watch out for
- A send and a credit return on the same edge leave the count unchanged.
- `in_ready` depends only on the credit counter, not on `in_valid`.
