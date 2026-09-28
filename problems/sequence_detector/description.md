Design a finite state machine that detects the serial bit pattern **`1011`** on `din`
(oldest bit first). **Overlapping** occurrences must be detected: the input
`1011011` contains the pattern twice.

`din` is sampled on each rising edge of `clk`. If the last four samples — including
the one just taken — were `1`, `0`, `1`, `1`, then `detected` must be `1` during the
clock cycle that follows that edge, and `0` otherwise (a Moore-style / registered output).

```
din samples :  1  0  1  1  0  1  1  1  0  1  1
detected    :  0  0  0  1  0  0  1  0  0  0  1   (value in the cycle after each sample)
```

### Reset

`rst` is synchronous and active high. It returns the FSM to its initial state
(no partial match) and clears `detected`.

### Interface

| Port       | Direction | Width |
|------------|-----------|-------|
| `clk`      | input  | 1 |
| `rst`      | input  | 1 |
| `din`      | input  | 1 |
| `detected` | output | 1 |
