Generate two sorted arrays that **interleave** perfectly: every element of `b` sits between the
corresponding element of `a` and the next one. It's useful for generating non-overlapping address
ranges `[a[i], b[i]]`.

### Class to complete

```systemverilog
class interleave;
    rand bit [7:0] a[6];
    rand bit [7:0] b[6];
    // constraints …
endclass
```
