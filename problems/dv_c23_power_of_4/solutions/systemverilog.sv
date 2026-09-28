class pow4;
    rand bit [31:0] v;

    constraint c { v != 0; (v & (v - 1)) == 0; (v & 32'h5555_5555) != 0; }
endclass
