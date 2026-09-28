**Debug problems** give you a design that *almost* works. The starter code is the buggy
version. Submit it as-is to see which checks fail and why, then find and fix the bugs.

This decade counter drives one digit of a multi-digit display: the `carry` output enables
the next digit. Users report that the display sometimes shows a digit **"A"**, and that the tens
digit sometimes advances while the counter is paused.

**2 bugs** are hidden in the code.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `en` | input | 1 |
| `digit` | output | 4 |
| `carry` | output | 1 |
