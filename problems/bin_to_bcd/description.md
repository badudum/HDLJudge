Seven-segment displays and decimal UIs want **BCD**: one 4-bit digit per decimal place.
Convert an 8-bit unsigned binary value to three BCD digits.

| `bin` | `bcd` (hex view) |
|-------|------------------|
| 7     | `0x007` |
| 42    | `0x042` |
| 199   | `0x199` |
| 255   | `0x255` |

The obvious `bin / 100`, `bin % 10` solution is **banned**. Dividers are big and slow in
hardware. Use the famous *double-dabble* (shift-and-add-3) algorithm instead.

### Interface

| Port  | Direction | Width |
|-------|-----------|-------|
| `bin` | input  | 8 |
| `bcd` | output | 12 (`[11:8]` hundreds, `[7:4]` tens, `[3:0]` ones) |
