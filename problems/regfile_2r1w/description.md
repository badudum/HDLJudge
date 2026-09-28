A RISC-V integer pipeline reads two source registers and writes one destination register
every cycle. Build that **register file**: 32 × 32-bit registers, two read ports, one write
port.

The read ports are **synchronous** (registered, like FPGA block RAM), and a read that hits
the register being written on the same edge returns the **new** value (*write-first* /
internal bypass). That removes a hazard the pipeline would otherwise have to handle.

```
edge:     1              2
we/waddr: 1 / x7         0
wdata:    0x1234
raddr2:   7              7
rdata2:   ── 0x1234 ───── 0x1234        (visible right after each edge)
```

Register **x0** is hardwired to zero.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `we` | input | 1 |
| `waddr`, `raddr1`, `raddr2` | input | 5 |
| `wdata` | input | 32 |
| `rdata1`, `rdata2` | output | 32 |
