Region-based constraints: the matrix is split into four 2 × 2 sub-squares, and each has a required
maximum. Tiled buffers and image-processing blocks use this kind of stimulus.

### Class to complete

```systemverilog
class quad_max;
    rand bit [3:0] m[4][4];
    // constraints …
endclass
```
