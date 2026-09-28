Implement a small **APB4** peripheral (AMBA Advanced Peripheral Bus). Every transfer has a setup
phase (`psel=1, penable=0`) followed by an access phase (`psel=1, penable=1`) in which it
completes.

```
pclk      _/‾\_/‾\_/‾\_
psel      __/‾‾‾‾‾‾‾\__
penable   ______/‾‾‾\__
          setup  access
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `pclk` | input | 1 |
| `presetn` | input | 1 |
| `psel` | input | 1 |
| `penable` | input | 1 |
| `pwrite` | input | 1 |
| `paddr` | input | 8 |
| `pwdata` | input | 32 |
| `pstrb` | input | 4 |
| `prdata` | output | 32 |
| `pready` | output | 1 |
| `pslverr` | output | 1 |
