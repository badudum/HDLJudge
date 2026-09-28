A hardware lock (mutex) for three masters: exclusive ownership, no stealing, and no revoking while held.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `lock_req` | input | 3 |
| `lock_gnt` | input | 3 |
