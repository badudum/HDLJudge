module bminmax (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] mn,
    output wire [7:0] mx
);
    wire [8:0] d = {a[7], a} - {b[7], b};    // 9 bits: no overflow
    wire [7:0] m = {8{d[8]}};                // all ones when a < b
    assign mn = b ^ ((a ^ b) & m);
    assign mx = a ^ ((a ^ b) & m);
endmodule
