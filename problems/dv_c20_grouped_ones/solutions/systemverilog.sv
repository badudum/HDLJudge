class two_groups;
    rand bit [15:0] v;

    constraint c_runs { $countones(v & ~{v[14:0], 1'b0}) == 2; }                      // run starts
    constraint c_len  { (v & ~{v[14:0], 1'b0} & ~{1'b0, v[15:1]}) == 16'h0; }   // no isolated ones
endclass
