### How it works

`call` pushes the return address and `ret` pops it, so a small stack in the fetch unit predicts return targets
almost perfectly. When the stack overflows (deep recursion), dropping the **oldest** entries keeps the innermost
returns, which are the ones that will execute next.

```
push A, B, C, D, E  →  stack holds B C D E (A dropped)
```

### Watch out for
- A push and a pop together replace the top entry (a tail call).
- Popping an empty stack does nothing.
