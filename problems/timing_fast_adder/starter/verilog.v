// Correct, but too slow: the synthesizer's generic adder is 16 levels deep.
// Replace it with a carry network that meets the 12-level budget.
module fast_add16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        cin,
    output wire [15:0] s,
    output wire        cout
);
    assign {cout, s} = a + b + cin;
endmodule
