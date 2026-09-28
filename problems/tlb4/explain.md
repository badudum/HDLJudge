### How it works

A fully associative TLB compares the virtual page number against every entry in parallel, like a
content-addressable memory (CAM). A match returns the physical page number. Misses are refilled by the page-table
walker. FIFO replacement uses a round-robin victim pointer:

```
lookup: hit = |(valid & (tag == vpn))
fill:   same vpn → update, else free slot → fill, else victim pointer → replace, advance
```

### Watch out for
- Never create two entries for the same vpn.
- The victim pointer only moves when it was used.
