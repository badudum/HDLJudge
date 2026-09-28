class no_zz;
    rand bit [15:0] v;

    constraint c { (~(v | {1'b0, v[15:1]}) & 16'h7FFF) == 16'h0; }  // no bit pair (v[i], v[i+1]) = 00
endclass
