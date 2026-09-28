Constraints on an **aggregate** (the maximum of each row) need helper variables. Here the row
maxima must be unique and increasing from top to bottom.

### Class to complete

```systemverilog
class row_max;
    rand bit [7:0] m[4][4];
    // constraints …
endclass
```
