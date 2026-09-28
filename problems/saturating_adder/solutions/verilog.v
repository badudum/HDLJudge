module sat_add8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] sum,
    output wire       ovf
);
    wire [8:0] s = {a[7], a} + {b[7], b};
    assign ovf = s[8] ^ s[7];
    assign sum = !ovf ? s[7:0] : (s[8] ? 8'h80 : 8'h7F);
endmodule
