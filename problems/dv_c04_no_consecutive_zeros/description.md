Constrain a 16-bit word so that **no two neighbouring bits are both 0**. Such words appear in
line-coding and run-length-limited (RLL) encoding tests. (Fun fact: there are 2584 of them, a
Fibonacci number.)

### Class to complete

```systemverilog
class no_zz;
    rand bit [15:0] v;
    // constraints …
endclass
```
