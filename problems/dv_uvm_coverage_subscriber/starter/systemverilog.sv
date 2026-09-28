class alu_cov extends uvm_subscriber #(alu_item);
    `uvm_component_utils(alu_cov)
    int op_hits[4];
    int a_bins[3];
    int zero_cross[4];
    bit big_b;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void write(alu_item t);
        // TODO
    endfunction

    function real get_coverage();
        // TODO
        return 0.0;
    endfunction
endclass
