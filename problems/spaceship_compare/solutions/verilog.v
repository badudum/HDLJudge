module cmp3 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [1:0] r
);
    wire [8:0] d = {a[7], a} - {b[7], b};
    assign r = {d[8], |d};
endmodule
