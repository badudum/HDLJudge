Realistic traffic isn't uniform. Use a weighted distribution for the packet class, and let the class decide the length range.

### Class to complete

```systemverilog
class pkt_mix;
    typedef enum bit [1:0] {SMALL, MEDIUM, LARGE} kind_e;
    rand kind_e kind;
    rand bit [7:0] len;
    // constraints …
endclass
```
