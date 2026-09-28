class stream_driver extends uvm_driver #(stream_item);
    `uvm_component_utils(stream_driver)
    virtual stream_if vif;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    // TODO: build_phase (get vif), run_phase (drive valid/data, wait for ready)
endclass

class stream_monitor extends uvm_monitor;
    `uvm_component_utils(stream_monitor)
    virtual stream_if vif;
    uvm_analysis_port #(stream_item) ap;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    // TODO: build_phase (get vif), run_phase (sample transfers, write to ap)
endclass
