Index-dependent constraints are the bread and butter of array randomization. Generate 12 bytes
where the element's parity matches its index's parity, and the even-indexed elements form a
strictly increasing sequence.

### Class to complete

```systemverilog
class even_odd;
    rand bit [7:0] arr[12];
    // constraints …
endclass
```
