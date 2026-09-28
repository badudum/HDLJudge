A deep dive into *distribution control*. Uniformly random bytes almost never have 0 or 8 bits set
(1 in 256). Corner cases like "all ones" and "all zeros" matter for parity, popcount and
priority logic, so generate bytes where the **number of ones** is uniform instead.

### Class to complete

```systemverilog
class popc_uniform;
    rand bit [7:0] v;
    // constraints …
endclass
```
