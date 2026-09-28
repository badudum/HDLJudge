class alu_cov extends uvm_subscriber #(alu_item);
    `uvm_component_utils(alu_cov)
    int op_hits[4];       // per opcode
    int a_bins[3];        // a == 0, a == 255, other
    int zero_cross[4];    // per opcode: a == 0 or b == 0
    bit big_b;            // some item had b == 255

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void write(alu_item t);
        op_hits[t.op]++;
        if (t.a == 8'd0)       a_bins[0]++;
        else if (t.a == 8'hFF) a_bins[1]++;
        else                   a_bins[2]++;
        if (t.a == 0 || t.b == 0) zero_cross[t.op]++;
        if (t.b == 8'hFF) big_b = 1;
    endfunction

    function real get_coverage();
        int hit = 0;
        foreach (op_hits[i])    if (op_hits[i] > 0) hit++;
        foreach (a_bins[i])     if (a_bins[i] > 0) hit++;
        foreach (zero_cross[i]) if (zero_cross[i] > 0) hit++;
        if (big_b) hit++;
        return 100.0 * hit / 12.0;
    endfunction
endclass
