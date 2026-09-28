Now the hard half of the UART: **receiving**. There is no clock on the wire, so the receiver
must find the start of each frame and sample every bit near its middle.

The line runs at 1/8 of the clock rate (8 clock cycles per bit), 8N1 format:

```
rx:  ‾‾‾‾‾‾‾|________|D0______|D1______| … |D7______|‾‾‾‾‾‾‾‾|‾‾‾
            ^E0  ^E0+4    ^E0+12    ^E0+20        ^E0+68   ^E0+76
               start       sample points (every 8 cycles)   stop
```

Protocol, counted in rising edges:

1. **Idle:** wait for a rising edge that samples `rx = 0`; call it **E₀**.
2. **E₀ + 4:** re-check the start bit. If `rx = 1`, it was a glitch, so go back to idle.
3. **E₀ + 12 + 8·i**, i = 0 … 7: sample data bit *i* (LSB first).
4. **E₀ + 76:** sample the stop bit.
   - `rx = 1`: the frame is good. Update `data` and set `valid = 1` for exactly one cycle.
   - `rx = 0`: set `frame_err = 1` for one cycle and keep the old `data`.

   Either way the receiver is back in idle after this edge, so the very next edge may detect a
   new start bit.

`rst` is synchronous: back to idle with `data = 0`.

### Interface

| Port        | Direction | Width |
|-------------|-----------|-------|
| `clk`       | input  | 1 |
| `rst`       | input  | 1 |
| `rx`        | input  | 1 |
| `data`      | output | 8 |
| `valid`     | output | 1 |
| `frame_err` | output | 1 |
