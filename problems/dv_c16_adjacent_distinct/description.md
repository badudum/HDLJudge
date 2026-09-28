Graph-coloring style constraints on a grid: no two neighbouring cells may share a color. Similar
constraints generate conflict-free bank assignments and interleaved memory layouts.

### Class to complete

```systemverilog
class coloring;
    rand bit [1:0] grid[4][4];
    // constraints …
endclass
```
