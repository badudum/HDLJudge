The classic N-queens puzzle with N = 8, solved by the randomization engine.

### Class to complete

```systemverilog
class queens;
    rand bit [2:0] col[8];     // queen in row r stands in column col[r]
    // constraints …
endclass
```
