module sext_var (
    input  wire [15:0] x,
    input  wire [3:0]  n,
    output wire [15:0] y
);
    wire [15:0] m    = 16'd1 << n;             // sign-bit position
    wire [15:0] mask = (m << 1) - 16'd1;       // n+1 ones (wraps to FFFF for n = 15)
    wire [15:0] v    = x & mask;
    assign y = (v ^ m) - m;
endmodule
