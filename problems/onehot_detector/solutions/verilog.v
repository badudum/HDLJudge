module onehot_check (
    input  wire [15:0] x,
    output wire        onehot,
    output wire        onehot0
);
    // x & (x - 1) clears the lowest set bit
    assign onehot0 = ((x & (x - 16'd1)) == 16'd0);
    assign onehot  = onehot0 && (x != 16'd0);
endmodule
