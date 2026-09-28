class five_run;
    rand bit [31:0] v;

    constraint c { $countones(v) == 5; $countones(v & (v >> 1)) == 4; }
endclass
