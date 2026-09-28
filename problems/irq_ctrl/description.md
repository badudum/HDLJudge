A minimal PLIC-style interrupt controller: edge detection, sticky pending bits, masking, a fixed-priority encoder and acknowledge. This is what sits between peripherals and a CPU's single interrupt line.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `irq_in` | input | 8 |
| `mask_we` | input | 1 |
| `mask_data` | input | 8 |
| `ack` | input | 1 |
| `irq` | output | 1 |
| `id` | output | 3 |
| `pending` | output | 8 |
| `mask` | output | 8 |
