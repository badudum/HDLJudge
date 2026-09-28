class parity_driver extends base_driver;
    `uvm_component_utils(parity_driver)
    int n_parity;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    // TODO: override process()
endclass

class my_test extends base_test;
    `uvm_component_utils(my_test)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        // TODO: config object, config_db, factory override
        super.build_phase(phase);
    endfunction
endclass
