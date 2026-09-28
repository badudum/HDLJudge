Generate a 32-bit mask with a single run of exactly **five** ones at a random position, e.g. a
5-bit field in a register or a 5-lane group of a SIMD mask.

### Class to complete

```systemverilog
class five_run;
    rand bit [31:0] v;
    // constraints …
endclass
```
