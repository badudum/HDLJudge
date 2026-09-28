DC-balanced words with limited run length are what line codes (8b/10b and friends) produce. Generate balanced 16-bit words with runs of at most three.

### Class to complete

```systemverilog
class balanced;
    rand bit [15:0] v;
    // constraints …
endclass
```
