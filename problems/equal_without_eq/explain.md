### How it works

Two words are equal when **no bit position differs**. XOR marks the differing positions, and a
reduction NOR (`~|`) turns "no bit set" into a single 1. In gates this is 16 XORs followed by a
NOR tree, which is exactly what `==` synthesizes to.

| a | b | a ^ b |
|---|---|-------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

### Watch out for
- `!` is logical NOT and works on the whole value, while `~` is bitwise. `~|v` is the reduction NOR of v.
