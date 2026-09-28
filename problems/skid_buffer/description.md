A **skid buffer** (or "full register slice") registers every signal of a valid/ready channel,
including `ready`, which flows backwards. The price is a second register that catches the word
already in flight when the output stalls.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `in_valid` | input | 1 |
| `in_data` | input | 8 |
| `in_ready` | output | 1 |
| `out_valid` | output | 1 |
| `out_data` | output | 8 |
| `out_ready` | input | 1 |
