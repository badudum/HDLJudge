// Functionally correct, but far too slow: the loop builds a 63-gate XOR chain.
// Restructure it to meet the 8-level timing budget.
module parity64 (
    input  wire [63:0] d,
    output reg         p
);
    integer i;
    always @(*) begin
        p = 1'b0;
        for (i = 0; i < 64; i = i + 1)
            p = p ^ d[i];
    end
endmodule
