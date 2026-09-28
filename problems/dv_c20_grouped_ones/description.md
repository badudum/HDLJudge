Structure inside a bit vector: the ones must come in exactly two blocks, each at least two bits
wide. Bit tricks with shifts express this compactly without loops.

### Class to complete

```systemverilog
class two_groups;
    rand bit [15:0] v;
    // constraints …
endclass
```
