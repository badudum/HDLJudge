class bus_agent extends uvm_agent;
    `uvm_component_utils(bus_agent)
    bus_driver drv;
    uvm_sequencer #(bus_item) sqr;
    bus_monitor mon;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // TODO: read this agent's is_active from uvm_config_db (field name "is_active");
        //       leave it at the UVM_ACTIVE default if nothing was set.
        // TODO: always build 'mon'. Only build 'drv' and 'sqr' when active.
    endfunction

    function void connect_phase(uvm_phase phase);
        // TODO: connect drv.seq_item_port to sqr.seq_item_export, only when active.
    endfunction
endclass
