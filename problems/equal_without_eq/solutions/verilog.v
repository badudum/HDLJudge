module eq16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    output wire        eq,
    output wire [15:0] diff_mask
);
    assign diff_mask = a ^ b;
    assign eq = ~|diff_mask;
endmodule
