**Timing problems** are judged on correctness *and* on the depth of the logic between
registers or ports. The Synthesis stage reports the **critical path**: the longest chain of
generic 2-input gates in your design. It is a technology-independent stand-in for the path
that limits the clock frequency.

This design computes the parity of a 64-bit word. The starter code is functionally correct, but
it builds a 63-gate chain. Restructure it to fit in **8 logic levels**.

```
chain:  d0 ─⊕─⊕─⊕─ … ─⊕─ p          63 levels
            d1 d2 d3    d63
tree:   ⊕⊕⊕⊕…  →  ⊕⊕…  →  …  →  ⊕   6 levels
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `d`  | input  | 64 |
| `p`  | output | 1 |
