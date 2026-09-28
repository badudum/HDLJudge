The two agent components that touch the pins: a **driver** that turns sequence items into
valid/ready handshakes, and a **passive monitor** that turns handshakes back into transactions
for scoreboards and coverage.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

interface stream_if (input logic clk);
    logic       rst;      // synchronous, active high (driven by the testbench)
    logic       valid;    // driver -> DUT
    logic [7:0] data;     // driver -> DUT
    logic       ready;    // DUT -> driver (random backpressure)
endinterface

class stream_item extends uvm_sequence_item;
    rand bit [7:0] data;
    `uvm_object_utils(stream_item)
    function new(string name = "stream_item"); super.new(name); endfunction
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

