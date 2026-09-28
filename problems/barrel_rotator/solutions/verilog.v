module rotator8 (
    input  wire [7:0] din,
    input  wire [2:0] amt,
    input  wire       dir,
    output wire [7:0] dout
);
    wire [15:0] dd = {din, din};
    wire [15:0] l  = dd << amt;     // upper byte = rotate left
    wire [15:0] r  = dd >> amt;     // lower byte = rotate right
    assign dout = dir ? r[7:0] : l[15:8];
endmodule
