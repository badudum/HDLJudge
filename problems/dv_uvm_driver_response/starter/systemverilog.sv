class mul_driver extends uvm_driver #(mul_item);
    `uvm_component_utils(mul_driver)
    virtual mul_if vif;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // TODO: get the virtual interface "vif" from uvm_config_db
    endfunction

    task run_phase(uvm_phase phase);
        // TODO: forever: get_next_item, drive the request, wait for done,
        //       and return a response to the sequence
    endtask
endclass
