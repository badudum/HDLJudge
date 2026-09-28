module add_sub #(
    parameter N = 8
) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    input  wire         sub,
    output wire [N-1:0] y,
    output wire         cout
);
    // one adder: invert b and use sub as the carry-in
    assign {cout, y} = {1'b0, a} + {1'b0, b ^ {N{sub}}} + sub;
endmodule
