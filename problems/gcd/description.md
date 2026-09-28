Build a small **iterative datapath with a start/done handshake**: a unit that computes the
greatest common divisor of two 16-bit unsigned numbers, one step per clock cycle.

```
clk    _/‾\_/‾\_/‾\_/‾\_/‾\_ … _/‾\_/‾\_/‾\_
start  ‾‾‾\______________________________
a, b   <48,18>----- don't care ----------
busy   ____/‾‾‾‾‾‾‾‾‾‾‾‾‾‾ … ‾‾‾\_______
done   ______________________ … _/‾\_____
result ======== old ========== … =<  6  >=
```

- **Start:** a rising edge with `start = 1` while idle latches `a` and `b`.
- **Busy:** from the next cycle, `busy = 1` until the answer is ready.
- **Done:** `done` pulses for one cycle. In that cycle `result` is valid and `busy` is already low,
  so a new `start` may be issued right away. `result` keeps its value afterwards.

The latency is up to you (the testbench waits up to 140 000 cycles), but you may not use the
`/` or `%` operators. Build the algorithm from comparisons, subtraction and shifts.

### Interface

| Port     | Direction | Width |
|----------|-----------|-------|
| `clk`    | input  | 1 |
| `rst`    | input  | 1 (synchronous, active high) |
| `start`  | input  | 1 |
| `a`, `b` | input  | 16 |
| `busy`   | output | 1 |
| `done`   | output | 1 |
| `result` | output | 16 |
