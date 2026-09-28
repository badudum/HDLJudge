class top_vseq extends uvm_sequence;
    `uvm_object_utils(top_vseq)
    uvm_sequencer #(cfg_item)  cfg_sqr;
    uvm_sequencer #(data_item) data_sqr;

    function new(string name = "top_vseq"); super.new(name); endfunction

    task body();
        // TODO
    endtask
endclass
