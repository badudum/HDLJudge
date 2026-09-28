The constraint solver as a puzzle solver: generate complete, valid Sudoku grids in the 6 × 6 variant (2 × 3 boxes) with two fixed clues.

### Class to complete

```systemverilog
class sudoku6;
    rand bit [2:0] g[6][6];
    // constraints …
endclass
```
