Network-stack verification needs addresses from specific ranges. Constrain an IPv4 address to the private ranges.

### Class to complete

```systemverilog
class ip_addr;
    rand bit [7:0] o[4];     // o[0].o[1].o[2].o[3]
    // constraints …
endclass
```
