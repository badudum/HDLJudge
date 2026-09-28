### How it works

Two rules, checked on every rising edge:

1. **Lock:** if the current owner still requests *and* holds its `lock` bit, the grant doesn't
   change. The owner is in the middle of an atomic read-modify-write that nobody may interrupt.
2. **Otherwise:** fixed priority, with master 0 highest.

```
req  = 111   lock = 100   owner = 2  →  owner stays 2 (locked)
req  = 111   lock = 000              →  owner becomes 0
```

### Watch out for
- `lock` without a request doesn't hold the bus.
- `owner` and `busy` are derived from the registered one-hot grant.
