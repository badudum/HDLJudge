In the classic 5-stage RISC pipeline (IF, ID, EX, MEM, WB), forwarding solves most data
hazards, but not the **load-use** case: a load's data only arrives at the end of MEM, one cycle
too late for an instruction right behind it. The **hazard detection unit** in ID spots this
and stalls one cycle. It also squashes wrong-path instructions after a taken branch
(resolved in EX).

```
lw  x5, 0(x2)      IF ID EX MEM WB
add x6, x5, x7        IF ID ** EX MEM WB     ← one-cycle stall, then x5 is forwarded
```

| Output | Meaning |
|--------|---------|
| `stall`        | hold the PC and the IF/ID register this cycle |
| `id_ex_bubble` | load a NOP into ID/EX instead of the ID instruction |
| `if_id_flush`  | turn the instruction in IF/ID into a NOP (wrong path) |

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `id_rs1`, `id_rs2`, `ex_rd` | input | 5 |
| `id_uses_rs1`, `id_uses_rs2`, `ex_mem_read`, `ex_branch_taken` | input | 1 |
| `stall`, `id_ex_bubble`, `if_id_flush` | output | 1 |
