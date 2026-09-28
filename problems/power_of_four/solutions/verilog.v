module pow4 (
    input  wire [15:0] x,
    output wire        p4
);
    assign p4 = (x != 16'd0) && ((x & (x - 16'd1)) == 16'd0) && ((x & 16'h5555) != 16'd0);
endmodule
