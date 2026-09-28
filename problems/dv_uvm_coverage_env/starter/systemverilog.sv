class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    bus_agent agent;
    bus_sb    sb;
    bus_cov   cov;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    // TODO: build_phase and connect_phase
endclass
