Generate arrays where **exactly one value is repeated exactly three times** and every other value is
unique. This is typical for directed-random tests of duplicate-detection logic, e.g. a CAM or a
hash table.

```
valid:   {3, 7, 3, 9, 0, 3, 5, 1, 14, 8}     3 appears three times
invalid: {3, 7, 3, 9, 0, 3, 5, 1, 14, 7}     7 also repeats
```

### Class to complete

```systemverilog
class three_same;
    rand bit [3:0] arr[10];
    // constraints …
endclass
```
