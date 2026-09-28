### How it works

Leakage current flows whether or not a cache line is used. A *drowsy* line lowers its supply to a
retention voltage: the data is kept, but it can't be read or written until the line wakes up again, which
costs one cycle. The simplest policy, putting every line to sleep periodically, works well because most
lines are idle most of the time.

```
access to a drowsy line → ready = 0, wake it → retry → ready = 1
```

### Watch out for
- Every 16 cycles all lines go drowsy, even ones just used.
- An access in that same cycle is resolved with the state from before the edge.
