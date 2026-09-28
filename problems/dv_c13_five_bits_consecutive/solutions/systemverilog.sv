class five_bits;
    rand bit [15:0] v;

    rand bit run;
    constraint c_cnt { $countones(v) == 5; }
    constraint c_run { run dist {1 := 30, 0 := 70}; run == ($countones(v & {1'b0, v[15:1]}) == 4); }
endclass
