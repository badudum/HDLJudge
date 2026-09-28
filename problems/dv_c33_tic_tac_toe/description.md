Model a game state as constraints: every result must be a legal tic-tac-toe position in which X has just won.

### Class to complete

```systemverilog
class ttt;
    rand bit [1:0] b[3][3];     // 0 = empty, 1 = X, 2 = O
    // constraints …
endclass
```
