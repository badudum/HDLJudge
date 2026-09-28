The two mechanisms that make UVM environments reusable: the **factory** (swap a component for a
derived one without touching the env) and **configuration objects** (parameterize an env from
the test). Write a test that uses both.

### Provided types (compiled before your code)

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class pkt_item extends uvm_sequence_item;
    bit [7:0] data;
    bit       parity;
    `uvm_object_utils(pkt_item)
    function new(string name = "pkt_item"); super.new(name); endfunction
endclass

class env_cfg extends uvm_object;
    int n_items       = 10;
    bit enable_parity = 0;
    `uvm_object_utils(env_cfg)
    function new(string name = "env_cfg"); super.new(name); endfunction
endclass

class base_driver extends uvm_driver #(pkt_item);
    `uvm_component_utils(base_driver)
    int n;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    virtual function void process(pkt_item t); endfunction      // hook for derived drivers
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            process(req);
            n++;
            #10ns;
            seq_item_port.item_done();
        end
    endtask
endclass

class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    env_cfg cfg;
    base_driver drv;
    uvm_sequencer #(pkt_item) sqr;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("NOCFG", "env_cfg 'cfg' not found in uvm_config_db")
        drv = base_driver::type_id::create("drv", this);
        sqr = uvm_sequencer#(pkt_item)::type_id::create("sqr", this);
    endfunction
    function void connect_phase(uvm_phase phase); drv.seq_item_port.connect(sqr.seq_item_export); endfunction
endclass

// Runs env.cfg.n_items items through the env.
class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    my_env env;
    pkt_item sent[$];
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        env = my_env::type_id::create("env", this);
        void'(uvm_factory::get().create_component_by_name("hwlc_checker", get_full_name(), "chk", this));
    endfunction
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        for (int i = 0; i < env.cfg.n_items; i++) begin
            pkt_item it = pkt_item::type_id::create("it");
            it.data = 8'($urandom);
            sent.push_back(it);
            env.sqr.execute_item(it);
        end
        phase.drop_objection(this);
    endtask
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

