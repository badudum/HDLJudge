### How it works

An ideal N-bit DAC maps a code to `code / 2ᴺ · VREF`. The step between codes (1 LSB) is VREF / 256. The
output register updates on the clock edge and holds between edges, like a real DAC's input latch.

| code | vout (VREF = 2.5) |
|------|-------------------|
| 0 | 0.0 |
| 1 | 0.00977 |
| 128 | 1.25 |
| 255 | 2.490 (full scale − 1 LSB) |

### Watch out for
- Divide as real numbers, not integers.
- Use the `VREF` parameter/generic: the judge sets it to 2.5.
