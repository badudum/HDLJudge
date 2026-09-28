class top_vseq extends uvm_sequence;
    `uvm_object_utils(top_vseq)
    uvm_sequencer #(cfg_item)  cfg_sqr;
    uvm_sequencer #(data_item) data_sqr;

    function new(string name = "top_vseq"); super.new(name); endfunction

    task cfg_write(bit [7:0] addr, bit [7:0] data);
        cfg_write_seq s = cfg_write_seq::type_id::create("s");
        s.addr = addr; s.data = data;
        s.start(cfg_sqr, this);
    endtask

    task body();
        data_burst_seq burst;
        cfg_write(8'h00, 8'h01);                 // enable
        cfg_write(8'h04, 8'h08);                 // burst length
        burst = data_burst_seq::type_id::create("burst");
        burst.n = 8;
        fork
            burst.start(data_sqr, this);
            cfg_write(8'h08, 8'hAB);             // runs while the burst is in flight
        join
        cfg_write(8'h00, 8'h00);                 // disable
    endtask
endclass
