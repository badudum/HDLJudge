module parity64 (
    input  wire [63:0] d,
    output wire        p
);
    assign p = ^d;      // reduction operator: balanced XOR tree, 6 levels
endmodule
