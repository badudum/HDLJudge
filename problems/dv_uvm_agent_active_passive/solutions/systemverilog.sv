class bus_agent extends uvm_agent;
    `uvm_component_utils(bus_agent)
    bus_driver drv;
    uvm_sequencer #(bus_item) sqr;
    bus_monitor mon;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active));
        mon = bus_monitor::type_id::create("mon", this);
        if (get_is_active() == UVM_ACTIVE) begin
            drv = bus_driver::type_id::create("drv", this);
            sqr = uvm_sequencer #(bus_item)::type_id::create("sqr", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE)
            drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass
