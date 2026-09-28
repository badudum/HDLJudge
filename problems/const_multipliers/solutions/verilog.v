module cmul (
    input  wire [7:0]  x,
    output wire [15:0] m7,
    output wire [15:0] m10,
    output wire [15:0] m255
);
    wire [15:0] x16 = {8'd0, x};
    assign m7   = (x16 << 3) - x16;
    assign m10  = (x16 << 3) + (x16 << 1);
    assign m255 = (x16 << 8) - x16;
endmodule
