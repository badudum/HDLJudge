Many protocols return something for every request: read data, a status, or a computed result.
In UVM the driver sends it back to the originating sequence through the **response path**. Write a driver for a
variable-latency multiplier that returns the result as a response item.

The hidden test runs one sequence, then two in parallel on the same sequencer. Every sequence
calls `get_response()` after each item and checks the result and the transaction id.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

interface mul_if (input logic clk);
    logic        req;      // driver -> DUT: start (one-cycle pulse, only while !busy)
    logic [7:0]  a, b;     // operands, valid with req
    logic        busy;     // DUT -> driver: an operation is in progress
    logic        done;     // DUT -> driver: result valid (one-cycle pulse)
    logic [15:0] result;
endinterface

class mul_item extends uvm_sequence_item;
    rand bit [7:0] a, b;
    bit [15:0]     result;
    `uvm_object_utils(mul_item)
    function new(string name = "mul_item"); super.new(name); endfunction
    function string convert2string(); return $sformatf("a=%0d b=%0d result=%0d", a, b, result); endfunction
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

