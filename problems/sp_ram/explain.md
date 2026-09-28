### How it works

A synchronous RAM registers its read data. In **read-first** mode, a read and a write to the same address
in one cycle return the old contents. Writing both assignments in one clocked block with nonblocking
assignments gives exactly that:

```
if (en) begin
    if (we) mem[addr] <= wdata;
    rdata <= mem[addr];     // old value
end
```

Synthesis tools recognize this template and map it onto block RAM instead of flip-flops.

### Watch out for
- `en = 0` freezes both the memory and `rdata`.
- No reset on the array: block RAMs can't be reset.
