module two_hot (
    input  wire [15:0] x,
    output wire        two
);
    wire [15:0] y = x & (x - 16'd1);             // drop the lowest set bit
    assign two = (y != 16'd0) && ((y & (y - 16'd1)) == 16'd0);
endmodule
