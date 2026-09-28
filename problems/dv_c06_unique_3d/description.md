Make all 27 elements of a 3-D array unique. The textbook one-liner is `unique {cube};`. But
simulators differ in how much of the LRM they implement, and here that one-liner silently does
nothing. Verification engineers learn to check that their constraints actually hold.

### Class to complete

```systemverilog
class unique3d;
    rand bit [5:0] cube[3][3][3];
    // constraints …
endclass
```
