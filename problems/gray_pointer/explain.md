### How it works

The read pointer has two copies. The **binary** pointer addresses the memory, and the **Gray** copy crosses into
the write domain through a synchronizer. Gray code changes one bit per increment, so a value sampled
mid-change is either the old pointer or the new one, never a random mix:

```
bin : 0000 0001 0010 0011 0100
gray: 0000 0001 0011 0010 0110
```

One extra MSB distinguishes full from empty (equal pointers are empty, and pointers equal except for the MSB are full).

### Watch out for
- Register the Gray copy: it must not glitch.
- `empty` compares Gray codes directly.
