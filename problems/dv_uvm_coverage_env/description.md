Wire an environment the reusable way: components come from the factory, optional pieces
are controlled through the configuration database, and the monitor's analysis port fans out
to every subscriber.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class bus_item extends uvm_sequence_item;
    bit [7:0] addr, data;
    `uvm_object_utils(bus_item)
    function new(string name = "bus_item"); super.new(name); endfunction
endclass

// Passive monitor: publishes 25 observed transfers (one every 10 ns).
class bus_monitor extends uvm_monitor;
    `uvm_component_utils(bus_monitor)
    uvm_analysis_port #(bus_item) ap;
    function new(string name, uvm_component parent); super.new(name, parent); ap = new("ap", this); endfunction
    task run_phase(uvm_phase phase);
        bus_item t;
        for (int i = 0; i < 25; i++) begin
            #10ns;
            t = bus_item::type_id::create("t");
            t.addr = i; t.data = 8'($urandom);
            ap.write(t);
        end
    endtask
endclass

class bus_agent extends uvm_agent;
    `uvm_component_utils(bus_agent)
    bus_monitor mon;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase); mon = bus_monitor::type_id::create("mon", this); endfunction
endclass

class bus_cov extends uvm_subscriber #(bus_item);
    `uvm_component_utils(bus_cov)
    int n;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    virtual function void write(bus_item t); n++; endfunction
endclass

class bus_sb extends uvm_component;
    `uvm_component_utils(bus_sb)
    uvm_analysis_imp #(bus_item, bus_sb) imp;
    int n;
    function new(string name, uvm_component parent); super.new(name, parent); imp = new("imp", this); endfunction
    function void write(bus_item t); n++; endfunction
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

