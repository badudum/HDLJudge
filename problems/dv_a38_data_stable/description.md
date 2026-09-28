A sender that holds `valid` while the receiver is not `ready` must keep its `data` **stable**.
Otherwise the receiver may capture a value that was never meant to be sent.

```
clk    _/‾\_/‾\_/‾\_/‾\_
valid  __/‾‾‾‾‾‾‾‾‾‾‾\___
ready  __________/‾‾‾\___
data   ==< D0        >===     must not change until the handshake
```

Write the assertion.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `ready` | input | 1 |
| `data` | input | 8 |
