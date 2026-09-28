Serial Peripheral Interface: the simplest synchronous serial bus. The master generates the clock,
shifts a byte out on MOSI, and simultaneously shifts a byte in from MISO.

```
cs_n  ‾‾\__________________________________/‾‾
sclk  ______/‾‾\__/‾‾\__ … __/‾‾\____________
mosi  ====X b7  X b6  X  …  X b0  X=========
            ↑ sample miso on each rising edge
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `start` | input | 1 |
| `tx_data` | input | 8 |
| `miso` | input | 1 |
| `sclk` | output | 1 |
| `mosi` | output | 1 |
| `cs_n` | output | 1 |
| `busy` | output | 1 |
| `done` | output | 1 |
| `rx_data` | output | 8 |
