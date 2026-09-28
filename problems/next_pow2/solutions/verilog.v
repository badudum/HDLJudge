module next_pow2 (
    input  wire [15:0] x,
    output wire [16:0] y
);
    wire [15:0] v0 = x - 16'd1;
    wire [15:0] v1 = v0 | (v0 >> 1);
    wire [15:0] v2 = v1 | (v1 >> 2);
    wire [15:0] v3 = v2 | (v2 >> 4);
    wire [15:0] v4 = v3 | (v3 >> 8);
    assign y = (x == 16'd0) ? 17'd1 : {1'b0, v4} + 17'd1;
endmodule
