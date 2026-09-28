### How it works

Clock gating is most effective at a fine grain. Here each byte of each register has its own
enable, so a byte-sized store only clocks 8 of the 128 flops. `cg_en` exposes the 16 enables so the gating can be
verified. In silicon each enable would drive an ICG cell.

### Watch out for
- An enable must be 1 **only** for the groups actually written this cycle.
- Reads are combinational and don't affect the enables.
