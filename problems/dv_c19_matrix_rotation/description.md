Constraints can relate two random variables structurally. Generate a matrix and its 90° clockwise
rotation together, e.g. to test an image-rotation engine with self-checking stimulus.

### Class to complete

```systemverilog
class rotated;
    rand bit [3:0] a[3][3];
    rand bit [3:0] b[3][3];
    // constraints …
endclass
```
