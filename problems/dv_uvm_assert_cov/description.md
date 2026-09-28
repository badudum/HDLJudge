Assertions are most useful when their results flow into the same reporting as the rest of the
testbench. Write a request/grant protocol checker whose assertion failures become UVM errors
with specific IDs, and whose cover properties feed coverage counters.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;
// No types needed: your module is instantiated as
//   hs_sva u_sva (.clk(clk), .rst(rst), .req(req), .gnt(gnt), .id(id));
// and the hidden UVM test reads u_sva.cov_b2b / u_sva.cov_max_wait and the UVM report server.
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `req` | input | 1 |
| `gnt` | input | 1 |
| `id` | input | 4 |
