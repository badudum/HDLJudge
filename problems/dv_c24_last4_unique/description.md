Stateful randomization: the constraint depends on what was generated before. Generate a stream where any four consecutive values are all different, e.g. to avoid back-to-back conflicts on the same bank or ID.

### Class to complete

```systemverilog
class window4;
    rand bit [3:0] val;
    // constraints …
endclass
```
