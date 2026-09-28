### How it works

SPI mode 0: the clock idles low, data is sampled on the rising edge, and it changes on the falling edge. The
master drives MOSI and reads MISO at the same time, so every transfer is full duplex:

```
cs_n  ‾‾\______________________________/‾‾
sclk  _____/‾‾\__/‾‾\__ … /‾‾\___________
mosi  ====X  b7  X  b6  X … X b0 X======
miso        ↑ sampled on every rising edge
```

A 6-bit counter of clock cycles drives everything: sclk toggles every 2 cycles and 8 bits take 32 cycles.

### Watch out for
- All outputs are registered.
- The first data bit must be on MOSI **before** the first rising sclk edge.
