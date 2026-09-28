A main road crosses a quiet side street that has a car sensor. The main road stays green
unless a car is waiting on the side street.

```
             car & ≥6 cycles              2 cycles
 MAIN_GREEN ───────────────▶ MAIN_YELLOW ─────────▶ SIDE_GREEN
     ▲                                                 │ 4 cycles
     │            2 cycles                             ▼
     └────────────────────────────────────────── SIDE_YELLOW
```

| State        | `main` | `side` | Duration |
|--------------|--------|--------|----------|
| MAIN_GREEN   | GREEN  | RED    | ≥ 6 cycles, until `car = 1` is sampled |
| MAIN_YELLOW  | YELLOW | RED    | 2 cycles |
| SIDE_GREEN   | RED    | GREEN  | 4 cycles |
| SIDE_YELLOW  | RED    | YELLOW | 2 cycles |

Encodings: RED = `2'd0`, YELLOW = `2'd1`, GREEN = `2'd2`.

"Lasts N cycles" counts the clock cycles during which the outputs show that state. A
synchronous reset puts the controller in MAIN_GREEN; the cycle after the reset edge is its
first cycle.

### Interface

| Port   | Direction | Width |
|--------|-----------|-------|
| `clk`  | input  | 1 |
| `rst`  | input  | 1 |
| `car`  | input  | 1 |
| `main` | output | 2 |
| `side` | output | 2 |
