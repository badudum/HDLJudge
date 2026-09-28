### How it works

The Cummings asynchronous FIFO:

1. Each side keeps a **binary** pointer (for addressing) and a **Gray** copy (for crossing).
2. Each Gray pointer crosses into the other domain through a 2-flop synchronizer.
3. **Empty** (read side): the next read Gray pointer equals the synchronized write pointer.
   **Full** (write side): the next write Gray pointer equals the synchronized read pointer with its two MSBs inverted.

Because the synchronized pointers lag, the flags are **pessimistic**: empty and full are released a few cycles
late. That wastes a little throughput but never loses data.

### Watch out for
- Register the flags from the *next* pointer values.
- The memory has 8 entries, and the pointers need 4 bits (one extra wrap bit).
