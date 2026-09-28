Valid/ready handshakes (AXI-Stream and friends) have one iron rule: **data transfers only
when valid and ready are both high**, and a sender holding valid must keep its data stable
until then.

This register slice sits between two such interfaces. In system tests, words occasionally
**vanish** under backpressure, and a continuous stream shows **bubbles** that halve the
throughput. **2 bugs**.

```
in_valid/in_ready ──▶ [ out_valid | out_data ] ──▶ out_valid/out_ready
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst` | input | 1 |
| `in_valid`, `out_ready` | input | 1 |
| `in_data` | input | 8 |
| `in_ready`, `out_valid` | output | 1 |
| `out_data` | output | 8 |
