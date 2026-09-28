Liveness-style checks bound how long a response may take. Here every request must be
acknowledged **1 to 5 cycles** later:

```
req  __/‾\__________________
ack  ____________/‾\________   ok (3 cycles)
ack  _______________________/‾\   too late (> 5)
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `ack` | input | 1 |
