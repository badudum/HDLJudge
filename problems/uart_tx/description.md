Implement the transmit side of a **UART**, the serial port that still connects almost every
microcontroller to a console.

Frames use the common **8N1** format and a fixed baud rate of 1/4 of the clock (every bit is
held for 4 clock cycles):

```
tx:  ‾‾‾‾|____|D0__|D1__|D2__|D3__|D4__|D5__|D6__|D7__|‾‾‾‾|‾‾‾‾
      idle start  data bits, LSB first               stop  idle
```

- While idle, `tx = 1` and `busy = 0`.
- A rising edge that samples `start = 1` while idle captures `data` and begins a frame. The
  start bit is visible in the very next cycle, and `busy` is 1 for the 40 cycles of the frame.
- `start` is ignored while a frame is in progress.
- `rst` is synchronous and returns the transmitter to idle immediately.

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `clk`   | input  | 1 |
| `rst`   | input  | 1 |
| `start` | input  | 1 |
| `data`  | input  | 8 |
| `tx`    | output | 1 |
| `busy`  | output | 1 |
