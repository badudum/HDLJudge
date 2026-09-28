### How it works

Combinational logic burns power whenever its inputs toggle, even when the result is ignored. Operand
isolation freezes the inputs of units that aren't needed. Here each unit has its own operand registers that load
only when that unit is selected, so the idle multiplier's inputs (and therefore its internal nodes) don't move.

### Watch out for
- Both operand registers of the **unused** unit must hold their values.
- `y` depends on the registered op, not on the current input `op`.
