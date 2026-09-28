class stream_driver extends uvm_driver #(stream_item);
    `uvm_component_utils(stream_driver)
    virtual stream_if vif;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual stream_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "vif not set")
    endfunction
    task run_phase(uvm_phase phase);
        vif.valid <= 1'b0;
        @(posedge vif.clk);
        while (vif.rst) @(posedge vif.clk);
        forever begin
            seq_item_port.get_next_item(req);
            vif.valid <= 1'b1;
            vif.data  <= req.data;
            do @(posedge vif.clk); while (!vif.ready);   // transfer on valid && ready
            vif.valid <= 1'b0;
            seq_item_port.item_done();
        end
    endtask
endclass

class stream_monitor extends uvm_monitor;
    `uvm_component_utils(stream_monitor)
    virtual stream_if vif;
    uvm_analysis_port #(stream_item) ap;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual stream_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "vif not set")
    endfunction
    task run_phase(uvm_phase phase);
        stream_item t;
        forever begin
            @(posedge vif.clk);
            if (!vif.rst && vif.valid === 1'b1 && vif.ready) begin
                t = stream_item::type_id::create("t");   // a fresh object for every transfer
                t.data = vif.data;
                ap.write(t);
            end
        end
    endtask
endclass
