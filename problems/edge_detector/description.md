Design a synchronous **rising edge detector**.

`din` is sampled on every rising edge of `clk`. When the value sampled at an edge
is `1` **and** the value sampled at the previous edge was `0`, the output `pulse`
must be `1` for exactly one clock cycle — the cycle that immediately follows that
edge. Otherwise `pulse` is `0`.

`pulse` must be a **registered** output (it only changes on rising edges of `clk`).

```
clk    _/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_
din    ____/‾‾‾‾‾‾‾‾‾‾‾\_______/‾‾‾‾
pulse  ______/‾‾‾\_____________/‾‾‾\
```

### Reset

`rst` is a synchronous, active-high reset. On a rising edge with `rst = 1`,
`pulse` becomes `0` and the stored "previous" sample becomes `0`.
(So if `din` is already `1` at the first edge after reset is released, that counts as a rising edge.)

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `clk`   | input  | 1 |
| `rst`   | input  | 1 |
| `din`   | input  | 1 |
| `pulse` | output | 1 |
