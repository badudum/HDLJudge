class parity_driver extends base_driver;
    `uvm_component_utils(parity_driver)
    int n_parity;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    virtual function void process(pkt_item t);
        t.parity = ^t.data;
        n_parity++;
    endfunction
endclass

class my_test extends base_test;
    `uvm_component_utils(my_test)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        env_cfg cfg = env_cfg::type_id::create("cfg");
        cfg.n_items = 25;
        cfg.enable_parity = 1;
        uvm_config_db#(env_cfg)::set(this, "env", "cfg", cfg);
        base_driver::type_id::set_type_override(parity_driver::get_type());
        super.build_phase(phase);                // builds the env with the override in place
    endfunction
endclass
