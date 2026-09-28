The harder twin of the classic: divisibility by 3 when the **least** significant bit arrives first. The weight of each new bit changes, so the FSM needs extra state.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `bit_in` | input | 1 |
| `d3` | output | 1 |
