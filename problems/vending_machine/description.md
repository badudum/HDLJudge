Design the controller of a vending machine that sells one item for **30¢** and accepts
nickels, dimes and quarters, one coin per clock cycle at most.

On each rising edge, the coin on `coin` (if any) is added to the credit:

- if the new total is **≥ 30¢**, the machine dispenses the item: in the following cycle
  `dispense = 1`, `change` = total − 30, and the credit is reset to 0;
- otherwise the total becomes the new credit and `dispense = 0`, `change = 0`.

```
coin:     Q     -     N     D     D     Q
credit:   25    25    0     10    20    0
dispense: 0     0     1     0     0     1
change:   0     0     0     0     0     15
```

(Each column shows the outputs right after the rising edge that sampled that coin.)

### Interface

| Port       | Direction | Width | Notes |
|------------|-----------|-------|-------|
| `clk`      | input  | 1 | |
| `rst`      | input  | 1 | synchronous, active high |
| `coin`     | input  | 2 | 0 none, 1 = 5¢, 2 = 10¢, 3 = 25¢ |
| `dispense` | output | 1 | one-cycle pulse |
| `change`   | output | 6 | cents, valid with `dispense` |
| `credit`   | output | 6 | cents inserted so far |
