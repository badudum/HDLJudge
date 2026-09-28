An **APB** (AMBA Advanced Peripheral Bus) transfer takes two cycles: a **SETUP** phase
(`psel = 1`, `penable = 0`) and an **ACCESS** phase (`psel = 1`, `penable = 1`), when the write
happens or the read data is sampled.

```
pclk     _/‾\_/‾\_/‾\_/‾\_
psel     __/‾‾‾‾‾‾‾\______
penable  ______/‾‾‾\______
paddr    --<  A        >--
          SETUP ACCESS
```

This peripheral has 4 registers. Firmware bring-up found three problems:

- writes to DATA also change CTRL,
- CONFIG reads 0 after reset,
- the ID register can be overwritten.

| Address | Name | Reset | Access |
|---------|------|-------|--------|
| 0x0 | CTRL   | 0x0000_0000 | R/W |
| 0x4 | CONFIG | 0x0000_00FF | R/W |
| 0x8 | DATA   | 0x0000_0000 | R/W |
| 0xC | ID     | 0xC0DE_0001 | RO  |

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `pclk`, `presetn`, `psel`, `penable`, `pwrite` | input | 1 |
| `paddr` | input | 4 |
| `pwdata` | input | 32 |
| `prdata` | output | 32 |
| `pready` | output | 1 |
