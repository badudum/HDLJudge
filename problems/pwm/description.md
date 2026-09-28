**Pulse-width modulation** controls motors, LEDs and switching power supplies by varying the
fraction of time a signal is high.

Build an 8-bit PWM generator:

- a free-running 8-bit counter `cnt` counts 0, 1, …, 255, 0, … (one step per clock);
- the output is high while `cnt < duty`.

```
duty = 3:   cnt:     0 1 2 3 4 5 … 255 0 1 2 3 …
            pwm_out: 1 1 1 0 0 0 …  0  1 1 1 0 …
```

`rst` (synchronous, active high) clears the counter to 0.

### Interface

| Port      | Direction | Width |
|-----------|-----------|-------|
| `clk`     | input  | 1 |
| `rst`     | input  | 1 |
| `duty`    | input  | 8 |
| `pwm_out` | output | 1 |
