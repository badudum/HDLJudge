module addsub_flags (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sub,
    output wire [7:0] y,
    output wire       carry,
    output wire       ovf
);
    wire [7:0] bb = b ^ {8{sub}};
    wire [8:0] t  = {1'b0, a} + {1'b0, bb} + sub;
    assign y     = t[7:0];
    assign carry = t[8];
    assign ovf   = (a[7] == bb[7]) && (y[7] != a[7]);
endmodule
