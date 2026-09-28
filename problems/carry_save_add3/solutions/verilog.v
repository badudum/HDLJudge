module add3 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    output wire [9:0] sum
);
    wire [7:0] s  = a ^ b ^ c;                    // per-bit sum
    wire [7:0] cy = (a & b) | (a & c) | (b & c);  // per-bit carry (weight 2)
    assign sum = {2'b00, s} + {1'b0, cy, 1'b0};   // the only carry-propagate adder
endmodule
