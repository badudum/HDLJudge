Report catchers intercept every UVM message before it reaches the report server. They're the
standard way to waive known issues and to silence noisy third-party VIP, without editing its
source.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;
// No provided types. The hidden test registers your catcher with
//   uvm_report_cb::add(null, catcher);
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

