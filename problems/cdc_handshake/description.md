The robust way to move a multi-bit value between unrelated clock domains when throughput isn't
critical: a **request/acknowledge handshake**. Only single control bits are synchronized. The
data is held stable in a register until the other side acknowledges it.

```
 domain A                               domain B
 a_data ─▶[hold]══════════ data ═══════════▶ b_data
 req ─────────────────▶[sync2]──▶ FSM ──▶ b_valid
 FSM ◀──[sync2]◀──────────────────── ack
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk_a` | input | 1 |
| `rst_a` | input | 1 |
| `a_valid` | input | 1 |
| `a_data` | input | 8 |
| `a_ready` | output | 1 |
| `clk_b` | input | 1 |
| `rst_b` | input | 1 |
| `b_valid` | output | 1 |
| `b_data` | output | 8 |
