class mul_driver extends uvm_driver #(mul_item);
    `uvm_component_utils(mul_driver)
    virtual mul_if vif;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual mul_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface 'vif' not set")
    endfunction

    task run_phase(uvm_phase phase);
        mul_item rsp;
        vif.req <= 1'b0;
        forever begin
            seq_item_port.get_next_item(req);
            @(posedge vif.clk);
            while (vif.busy) @(posedge vif.clk);
            vif.a <= req.a; vif.b <= req.b; vif.req <= 1'b1;
            @(posedge vif.clk);
            vif.req <= 1'b0;
            do @(posedge vif.clk); while (!vif.done);
            rsp = mul_item::type_id::create("rsp");
            rsp.set_id_info(req);                 // route the response back to its sequence
            rsp.a = req.a; rsp.b = req.b;
            rsp.result = vif.result;
            seq_item_port.item_done(rsp);         // same as item_done() + put_response(rsp)
        end
    endtask
endclass
