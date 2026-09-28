class balanced;
    rand bit [15:0] v;

    constraint c_bal { $countones(v) == 8; v[15] == 1'b1; }
    constraint c_run { (v & {1'b0, v[15:1]} & {2'b0, v[15:2]} & {3'b0, v[15:3]} & 16'h1FFF) == 16'h0;       // 1111
                       (~(v | {1'b0, v[15:1]} | {2'b0, v[15:2]} | {3'b0, v[15:3]}) & 16'h1FFF) == 16'h0; } // 0000
endclass
