### How it works

The address splits into **tag** and **index**. The index selects one line, and the stored tag says which of the 32
addresses that map to this line is currently cached:

```
addr[7:3] = tag   addr[2:0] = index
hit = valid[index] && tag[index] == addr[7:3]
```

Two addresses with the same index but different tags evict each other. These are *conflict misses*, the
weakness of direct-mapped caches. Write-through with no write-allocate means a write miss leaves the cache
unchanged, and a write hit updates the cached copy.

### Watch out for
- The lookup result is registered: `hit` describes the access of the previous edge.
- `inv` clears every valid bit, but not the tags or data (they're just ignored).
