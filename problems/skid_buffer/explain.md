### How it works

A plain pipeline register can register valid/data, but its `in_ready` still depends combinationally on
`out_ready`, so a long ready path stays long. Registering ready means the upstream finds out about a stall
one cycle late, and by then it has already sent one more word. The **skid register** catches that word:

```
out stalls ─▶ in_ready still 1 this cycle ─▶ in-flight word → skid
next cycle   in_ready = 0 (registered)
out ready  ─▶ main ← skid (skid drains first, keeps order)
```

### Watch out for
- The skid entry is older than anything on the input: drain it first.
- Full throughput: with `out_ready = 1` one word passes per cycle.
