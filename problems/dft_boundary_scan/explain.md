### How it works

Each pin gets a two-stage cell. The **capture/shift** flop takes part in a shift register chained through all
pins. The **update** flop holds the value driven to the pin in test mode, so the pins don't ripple while
new data is being shifted in:

```
          capture        shift            update
pins ──▶ [cap] ◀─ scan_in … ─▶ scan_out   [upd] ──▶ pins (mode = 1)
```

SAMPLE captures the functional pin values and shifts them out. EXTEST shifts in test values, updates
them, and drives them onto the board to test the interconnect.

### Watch out for
- `scan_out` comes from the last cell's capture flop.
- In normal mode (`mode = 0`), the pins pass straight through.
