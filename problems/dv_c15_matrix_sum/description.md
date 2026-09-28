Two-dimensional sum constraints: build 4 × 4 binary matrices where every row **and** every column
contains exactly two ones. Such matrices show up as crossbar connection masks and as load-balanced
assignment tables.

### Class to complete

```systemverilog
class bin_matrix;
    rand bit m[4][4];
    // constraints …
endclass
```
