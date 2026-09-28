module lsb_tricks (
    input  wire [15:0] x,
    output wire [15:0] iso,
    output wire [15:0] clr,
    output wire [15:0] tmask
);
    assign iso   = x & (~x + 16'd1);     // x & -x
    assign clr   = x & (x - 16'd1);
    assign tmask = ~x & (x - 16'd1);
endmodule
