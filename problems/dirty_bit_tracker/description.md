A **write-back** cache doesn't write stores to memory immediately. It marks the line
**dirty**, and only when a dirty line is evicted does its data have to be written back. Clean
lines can simply be dropped.

Track the valid and dirty state of an 8-line cache and signal write-backs:

| `op` | Meaning | New state of line `index` | Write-back? |
|------|---------|---------------------------|-------------|
| 00 | idle | — | no |
| 01 | write | valid, dirty | no |
| 10 | fill | valid, clean | if the old line was valid and dirty |
| 11 | invalidate | invalid, clean | if the old line was valid and dirty |

`writeback` is a one-cycle pulse right after the evicting edge, with the line number in
`wb_index`.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst` | input | 1 |
| `op` | input | 2 |
| `index` | input | 3 |
| `valid`, `dirty` | output | 8 |
| `writeback` | output | 1 |
| `wb_index` | output | 3 |
