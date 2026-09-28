Most data hazards in a 5-stage pipeline are fixed by **forwarding**: the ALU operand muxes
in EX take a result straight from a later pipeline register instead of waiting for it to be
written back.

```
add x3, x1, x2     IF ID EX MEM WB
sub x5, x3, x4        IF ID EX  MEM WB      x3 comes from EX/MEM   (fwd = 10)
or  x6, x3, x7           IF ID  EX  MEM WB  x3 comes from MEM/WB   (fwd = 01)
```

Produce the two operand-mux selects:

| `fwd` | Source |
|-------|--------|
| `00` | register file |
| `10` | EX/MEM (1 instruction ahead) |
| `01` | MEM/WB (2 instructions ahead) |

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `ex_rs1`, `ex_rs2`, `mem_rd`, `wb_rd` | input | 5 |
| `mem_reg_write`, `wb_reg_write` | input | 1 |
| `fwd_a`, `fwd_b` | output | 2 |
