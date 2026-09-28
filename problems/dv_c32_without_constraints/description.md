A common interview twist: produce a random permutation **without** constraints. Knowing the randomization hooks (`pre_randomize`, `post_randomize`) and array methods matters as much as knowing constraint syntax.

### Class to complete

```systemverilog
class perm10;
    rand bit dummy;                // randomize() must succeed
    int perm[10];                 // must hold a random permutation of 0..9 after randomize()
    // constraints …
endclass
```
