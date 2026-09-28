Pipelines waste power when bubbles flow through them: the data flops keep toggling with garbage. **Data gating** lets a stage's registers load only when valid data arrives, which is both cheaper and easier to debug.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `in_valid` | input | 1 |
| `in_data` | input | 8 |
| `out_valid` | output | 1 |
| `out_data` | output | 8 |
