Dynamic arrays let the *size* be random too. Generate arrays of random length with repetition
rules:

- 5 … 12 elements, each 0 … 9,
- no value more than twice,
- no two neighbours equal.

```
valid:   {3, 1, 3, 8, 1, 0}
invalid: {3, 3, 1, 8}          neighbours equal
invalid: {2, 5, 2, 7, 2}       2 appears three times
```

### Class to complete

```systemverilog
class rep_rules;
    rand int unsigned len;
    rand bit [7:0] arr[];
    // constraints …
endclass
```
