Generate sparse masks: exactly five ones, never two side by side (useful for stressing arbiters with non-neighbouring requesters).

### Class to complete

```systemverilog
class sparse5;
    rand bit [15:0] v;
    // constraints …
endclass
```
