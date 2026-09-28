Hit a corner case at a controlled rate: address comparators, hazard detectors and caches all have
logic for "the low bits match". Make that happen in **5 %** of the generated `(a, b)` pairs, no more
and no less.

### Class to complete

```systemverilog
class low_match;
    rand bit [7:0] a;
    rand bit [7:0] b;
    // constraints …
endclass
```
