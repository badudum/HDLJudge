The value range depends on the container's own size: a queue of n elements holds values below 10·n, sorted ascending.

### Class to complete

```systemverilog
class size_q;
    rand bit [7:0] q[$];
    // constraints …
endclass
```
