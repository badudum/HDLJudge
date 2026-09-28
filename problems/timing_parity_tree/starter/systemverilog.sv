// Functionally correct, but far too slow: the loop builds a 63-gate XOR chain.
// Restructure it to meet the 8-level timing budget.
module parity64 (
    input  logic [63:0] d,
    output logic        p
);
    always_comb begin
        p = 1'b0;
        for (int i = 0; i < 64; i++)
            p = p ^ d[i];
    end
endmodule
