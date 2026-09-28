class sparse5;
    rand bit [15:0] v;

    constraint c { $countones(v) == 5; (v & {1'b0, v[15:1]}) == 16'h0; }
endclass
