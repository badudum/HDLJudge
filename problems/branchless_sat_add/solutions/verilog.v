module bsat (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] y
);
    wire [8:0] s = {1'b0, a} + {1'b0, b};
    assign y = s[7:0] | {8{s[8]}};        // carry out saturates every bit
endmodule
