Combine a hard constraint (exactly five ones) with a probabilistic one: about 30 % of the time the
ones must form a single contiguous block. This is the kind of mask generator used to test
byte-enable and burst logic.

### Class to complete

```systemverilog
class five_bits;
    rand bit [15:0] v;
    // constraints …
endclass
```
