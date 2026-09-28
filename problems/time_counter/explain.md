### How it works

Four cascaded counters, each advancing only when every counter below it wraps:

```
ms  wraps 999 → 0    ─▶ sec++
sec wraps  59 → 0    ─▶ min++    (only when ms also wraps)
min wraps  59 → 0    ─▶ hr++     (… and sec)
hr  wraps  23 → 0
```

A cascade is smaller and easier to verify than one big binary millisecond counter followed by dividers.

### Watch out for
- The carry into a counter is the AND of all the wrap conditions below it.
- `load` has priority over `tick_ms`.
