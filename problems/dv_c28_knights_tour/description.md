A famous search problem as a constraint puzzle: the knight must visit every square of a 3 × 4 board exactly once. It shows how to encode permutations and path rules.

### Class to complete

```systemverilog
class knight_tour;
    rand bit [1:0] r[12];    // row (0..2) of the k-th square visited
    rand bit [1:0] c[12];    // column (0..3) of the k-th square visited
    // constraints …
endclass
```
