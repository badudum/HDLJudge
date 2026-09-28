module alt16 (
    input  wire [15:0] x,
    output wire        alt
);
    wire [15:0] y = x ^ (x >> 1);      // 1 where neighbours differ
    assign alt = &y[14:0];
endmodule
