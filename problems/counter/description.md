Design a **4-bit up counter** with a synchronous reset and a count enable.

On every **rising edge** of `clk`:

1. if `rst` is `1`, `count` becomes `0` (reset has priority over enable);
2. otherwise, if `en` is `1`, `count` increments by one, wrapping from `15` back to `0`;
3. otherwise `count` holds its value.

### Interface

| Port    | Direction | Width | Description |
|---------|-----------|-------|-------------|
| `clk`   | input  | 1 | clock, rising-edge triggered |
| `rst`   | input  | 1 | **synchronous**, active-high reset |
| `en`    | input  | 1 | count enable |
| `count` | output | 4 | current count |
