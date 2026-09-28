Logic BIST replaces the tester's patterns with an on-chip pseudo-random pattern generator. It's an LFSR followed by a phase shifter that decorrelates the scan chains.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `load` | input | 1 |
| `seed` | input | 16 |
| `en` | input | 1 |
| `state` | output | 16 |
| `chains` | output | 4 |
