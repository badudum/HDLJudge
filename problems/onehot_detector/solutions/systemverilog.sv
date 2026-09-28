module onehot_check (
    input  logic [15:0] x,
    output logic        onehot,
    output logic        onehot0
);
    assign onehot0 = (x & (x - 1'b1)) == '0;
    assign onehot  = onehot0 && |x;
endmodule
