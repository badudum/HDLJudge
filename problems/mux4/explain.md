### How it works

A 4:1 multiplexer selects one of four inputs. In Verilog, a `case` statement inside `always @(*)` or a
nested conditional expression both synthesize to the same logic. Make sure every path assigns the output,
otherwise synthesis infers a latch.

### Watch out for
- The output must react to `sel` alone: no clock and no stored value.
- Cover all four `sel` values (or add a default).
