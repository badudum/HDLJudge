Every JTAG-capable chip contains a **TAP controller**, a 16-state machine driven only by
the `TMS` pin, sampled on rising edges of `TCK`. It sequences boundary scan, debug access and
in-system programming.

| State | Code | TMS = 0 → | TMS = 1 → |
|-------|------|-----------|-----------|
| Test-Logic-Reset | F | Run-Test/Idle | Test-Logic-Reset |
| Run-Test/Idle | C | Run-Test/Idle | Select-DR-Scan |
| Select-DR-Scan | 7 | Capture-DR | Select-IR-Scan |
| Capture-DR | 6 | Shift-DR | Exit1-DR |
| Shift-DR | 2 | Shift-DR | Exit1-DR |
| Exit1-DR | 1 | Pause-DR | Update-DR |
| Pause-DR | 3 | Pause-DR | Exit2-DR |
| Exit2-DR | 0 | Shift-DR | Update-DR |
| Update-DR | 5 | Run-Test/Idle | Select-DR-Scan |
| Select-IR-Scan | 4 | Capture-IR | Test-Logic-Reset |
| Capture-IR | E | Shift-IR | Exit1-IR |
| Shift-IR | A | Shift-IR | Exit1-IR |
| Exit1-IR | 9 | Pause-IR | Update-IR |
| Pause-IR | B | Pause-IR | Exit2-IR |
| Exit2-IR | 8 | Shift-IR | Update-IR |
| Update-IR | D | Run-Test/Idle | Select-DR-Scan |

Outputs: `state` (the code above), plus one-hot decodes `shift_dr`, `shift_ir`,
`capture_dr`, `update_dr` and `tlr` (Test-Logic-Reset).

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `tck`, `trst`, `tms` | input | 1 |
| `state` | output | 4 |
| `shift_dr`, `shift_ir`, `capture_dr`, `update_dr`, `tlr` | output | 1 |
