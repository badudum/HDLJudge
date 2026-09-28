Power gating destroys state. **Retention registers** keep a copy in an always-on shadow latch, so a block can be switched off and resume where it left off.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `pwr_on` | input | 1 |
| `save` | input | 1 |
| `restore` | input | 1 |
| `en` | input | 1 |
| `d` | input | 8 |
| `q_out` | output | 8 |
