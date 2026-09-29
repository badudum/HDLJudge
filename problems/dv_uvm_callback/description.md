Two different UVM mechanisms let a test change a component's behavior without touching its code:
a **factory override** swaps in a whole different class, while a **callback** lets you hook into
specific points *inside* an existing component — without subclassing it at all. Write a callback
that injects a fault into a driver's output.

`cb_driver` (provided, fully implemented) calls every callback registered on it via `pre_drive`
immediately before it drives each item. The hidden test runs 15 items with no callback attached
(the driver must pass the data straight through), then registers your callback on the very same
driver instance and runs 15 more (every one of those must come out inverted).

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

interface cb_if (input logic clk);
    logic       valid;   // one-cycle pulse
    logic [7:0] data;    // valid together with valid
endinterface

class cb_item extends uvm_sequence_item;
    rand bit [7:0] data;
    `uvm_object_utils(cb_item)
    function new(string name = "cb_item"); super.new(name); endfunction
endclass

// Base callback: does nothing. Extend it and override pre_drive to change
// an item just before the driver sends it.
class my_callback extends uvm_callback;
    function new(string name = "my_callback"); super.new(name); endfunction
    virtual function void pre_drive(cb_item item);
    endfunction
endclass

// Fully implemented. For every item, runs every callback registered on this
// driver instance (in registration order) via `pre_drive`, then drives
// whatever the callback(s) left in `item.data`.
class cb_driver extends uvm_driver #(cb_item);
    `uvm_component_utils(cb_driver)
    `uvm_register_cb(cb_driver, my_callback)
    virtual cb_if vif;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual cb_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface 'vif' not set")
    endfunction
    task run_phase(uvm_phase phase);
        vif.valid <= 1'b0;
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_do_callbacks(cb_driver, my_callback, pre_drive(req))
            @(posedge vif.clk);
            vif.data <= req.data; vif.valid <= 1'b1;
            @(posedge vif.clk);
            vif.valid <= 1'b0;
            seq_item_port.item_done();
        end
    endtask
endclass

// Fully implemented: samples the bus and broadcasts every transfer on `ap`.
class cb_monitor extends uvm_monitor;
    `uvm_component_utils(cb_monitor)
    virtual cb_if vif;
    uvm_analysis_port #(cb_item) ap;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual cb_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface 'vif' not set")
    endfunction
    task run_phase(uvm_phase phase);
        cb_item it;
        forever begin
            @(posedge vif.clk);
            if (vif.valid) begin
                it = cb_item::type_id::create("it");
                it.data = vif.data;
                ap.write(it);
            end
        end
    endtask
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
