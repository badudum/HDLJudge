The **4-phase handshake** is the simplest robust way to hand data across a boundary:

```
req      ___/‾‾‾‾‾‾‾‾‾‾‾\__________
ack      _______/‾‾‾‾‾‾‾‾‾‾‾‾\_____
data_in  ===<   D0   >=============
           1   2      3       4
1. sender raises req (data valid)  2. receiver captures, raises ack
3. sender drops req                4. receiver drops ack
```

This receiver delivers **duplicate words** when the sender is slow, and sometimes delivers
**garbage**. **2 bugs**.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `req` | input | 1 |
| `data_in` | input | 8 |
| `ack`, `strobe` | output | 1 |
| `data_out` | output | 8 |
