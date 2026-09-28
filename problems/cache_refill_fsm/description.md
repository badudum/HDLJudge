When a write-back cache misses, the controller may have to **write back** the dirty victim
line before it can **refill** the set with the requested line. Both transfers are 4-beat
bursts over a memory interface that acknowledges one beat at a time.

```
IDLE ──miss & dirty──▶ WRITEBACK (4 beats) ──▶ REFILL (4 beats) ──▶ DONE ──▶ IDLE
  └───miss & clean───────────────────────────▲
```

| State | `mem_req` | `mem_we` | `mem_addr` | `done` |
|-------|-----------|----------|------------|--------|
| IDLE | 0 | – | – | 0 |
| WRITEBACK | 1 | 1 | `{victim_line, beat}` | 0 |
| REFILL | 1 | 0 | `{miss_line, beat}` | 0 |
| DONE | 0 | – | – | 1 |

A beat completes on each rising edge where `mem_ack = 1`. The memory in the testbench adds
random wait states.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `miss`, `dirty`, `mem_ack` | input | 1 |
| `miss_line`, `victim_line` | input | 8 |
| `mem_req`, `mem_we`, `done` | output | 1 |
| `mem_addr` | output | 10 |
