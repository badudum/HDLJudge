Boundary scan puts a shift-register cell on every pin, so that board-level interconnects can be tested without probes (EXTEST), and pin values can be sampled while the chip runs (SAMPLE). Build a 4-pin boundary-scan register.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `capture_dr` | input | 1 |
| `shift_dr` | input | 1 |
| `update_dr` | input | 1 |
| `mode` | input | 1 |
| `scan_in` | input | 1 |
| `data_in` | input | 4 |
| `data_out` | output | 4 |
| `scan_out` | output | 1 |
