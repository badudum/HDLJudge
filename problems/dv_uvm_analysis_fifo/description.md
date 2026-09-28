The predictor and the DUT produce the same packets at very different times, so the scoreboard
must buffer both sides. `uvm_tlm_analysis_fifo` turns the non-blocking analysis `write()` calls into a
blocking `get()` interface, which gives the classic in-order scoreboard.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class pkt extends uvm_sequence_item;
    bit [15:0] id;
    bit [31:0] payload;
    `uvm_object_utils(pkt)
    function new(string name = "pkt"); super.new(name); endfunction
    function string convert2string(); return $sformatf("id=%0d payload=0x%08h", id, payload); endfunction
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

