The translation lookaside buffer caches page-table entries so that most memory accesses translate in a single cycle. A small TLB is a CAM: every entry is compared at once.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `vpn` | input | 8 |
| `hit` | output | 1 |
| `ppn` | output | 8 |
| `fill` | input | 1 |
| `fill_vpn` | input | 8 |
| `fill_ppn` | input | 8 |
| `flush` | input | 1 |
