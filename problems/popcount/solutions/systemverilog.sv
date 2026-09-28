module popcount16 (
    input  logic [15:0] x,
    output logic [4:0]  count
);
    // SWAR adder tree
    logic [15:0] s1, s2, s3, s4;
    assign s1 = x - ((x >> 1) & 16'h5555);
    assign s2 = (s1 & 16'h3333) + ((s1 >> 2) & 16'h3333);
    assign s3 = (s2 + (s2 >> 4)) & 16'h0F0F;
    assign s4 = s3 + (s3 >> 8);
    assign count = s4[4:0];
endmodule
