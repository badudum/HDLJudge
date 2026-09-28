module g2b32 (
    input  wire [31:0] g,
    output wire [31:0] b
);
    wire [31:0] t1 = g  ^ (g  >> 1);
    wire [31:0] t2 = t1 ^ (t1 >> 2);
    wire [31:0] t3 = t2 ^ (t2 >> 4);
    wire [31:0] t4 = t3 ^ (t3 >> 8);
    assign b = t4 ^ (t4 >> 16);
endmodule
