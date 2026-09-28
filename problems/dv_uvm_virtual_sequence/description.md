Real tests coordinate several interfaces: configure the DUT through one agent, stream data through
another, poke a register in the middle. A **virtual sequence** runs on no sequencer of its own.
It orchestrates sub-sequences on the agents' sequencers.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class cfg_item extends uvm_sequence_item;
    bit [7:0] addr, data;
    `uvm_object_utils(cfg_item)
    function new(string name = "cfg_item"); super.new(name); endfunction
endclass

class data_item extends uvm_sequence_item;
    bit [7:0] payload;
    `uvm_object_utils(data_item)
    function new(string name = "data_item"); super.new(name); endfunction
endclass

// One register write on the configuration agent.
class cfg_write_seq extends uvm_sequence #(cfg_item);
    `uvm_object_utils(cfg_write_seq)
    bit [7:0] addr, data;
    function new(string name = "cfg_write_seq"); super.new(name); endfunction
    task body();
        cfg_item it = cfg_item::type_id::create("it");
        start_item(it); it.addr = addr; it.data = data; finish_item(it);
    endtask
endclass

// A burst of n data items (payload 0, 1, 2, ...) on the data agent.
class data_burst_seq extends uvm_sequence #(data_item);
    `uvm_object_utils(data_burst_seq)
    int n = 1;
    function new(string name = "data_burst_seq"); super.new(name); endfunction
    task body();
        for (int i = 0; i < n; i++) begin
            data_item it = data_item::type_id::create("it");
            start_item(it); it.payload = i; finish_item(it);
        end
    endtask
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

