A UVM agent bundles a driver, a sequencer and a monitor around one interface, but not every agent
in an environment should generate traffic. A **passive** agent only watches the bus — usually
because something else in the environment (or a real bus master upstream) is already driving
it — while an **active** agent also drives it. Write the `bus_agent` that assembles the pieces
correctly for both.

The hidden test builds two `bus_agent`s: one configured active, driving 20 items through its own
sequencer, and one configured passive, watching 15 transfers that are driven directly onto its bus
by something outside the agent entirely. Both agents' monitors must report everything they see,
and the passive agent must never have built a driver or sequencer at all.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

interface bus_if (input logic clk);
    logic       valid;   // one-cycle pulse
    logic [7:0] data;    // valid together with valid
endinterface

class bus_item extends uvm_sequence_item;
    rand bit [7:0] data;
    `uvm_object_utils(bus_item)
    function new(string name = "bus_item"); super.new(name); endfunction
    function string convert2string(); return $sformatf("data=%0d", data); endfunction
endclass

// Fully implemented: drives one item per clock pair. Counts how many times
// it is ever constructed, so the hidden test can check a passive agent
// never builds one.
class bus_driver extends uvm_driver #(bus_item);
    `uvm_component_utils(bus_driver)
    static int built = 0;
    virtual bus_if vif;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        built++;
        if (!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface 'vif' not set")
    endfunction
    task run_phase(uvm_phase phase);
        vif.valid <= 1'b0;
        forever begin
            seq_item_port.get_next_item(req);
            @(posedge vif.clk);
            vif.data <= req.data; vif.valid <= 1'b1;
            @(posedge vif.clk);
            vif.valid <= 1'b0;
            seq_item_port.item_done();
        end
    endtask
endclass

// Fully implemented: samples the bus and broadcasts every transfer on `ap`.
class bus_monitor extends uvm_monitor;
    `uvm_component_utils(bus_monitor)
    virtual bus_if vif;
    uvm_analysis_port #(bus_item) ap;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface 'vif' not set")
    endfunction
    task run_phase(uvm_phase phase);
        bus_item it;
        forever begin
            @(posedge vif.clk);
            if (vif.valid) begin
                it = bus_item::type_id::create("it");
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
