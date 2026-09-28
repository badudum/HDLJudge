This FSM should flag every occurrence of the bit pattern **1101**, including overlapping ones:

```
din   : 1 1 0 1 1 0 1 0 0
found : 0 0 0 1 0 0 1 0 0
```

It passed a quick directed test, but in system simulation it misses the second match of
`1101101`. It also behaves differently in simulation than on the FPGA. Find the **2 bugs**.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `din` | input | 1 |
| `found` | output | 1 |
