**Constraint problems** exercise SystemVerilog's constrained-random stimulus: you declare
`rand` variables and `constraint` blocks, and the solver finds values that satisfy them. The
hidden testbench calls `randomize()` hundreds of times and checks both the **rules** and the
**randomness** of the results.

Write a class `sum_item`:

```systemverilog
class sum_item;
    rand bit [7:0] arr[8];
    // constraints here
endclass
```

such that every successful `randomize()` produces an array where

- the elements add up to **200**,
- each element is in **5 … 60**,
- `arr[0]` is **even**.

Portability pitfall: by the language standard, `arr.sum()` of `bit [7:0]` elements has the
element's width (8 bits) and can wrap around. Some simulators widen it, others do not. The
testbench checks the true integer sum.
