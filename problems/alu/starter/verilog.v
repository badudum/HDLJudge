module alu #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [3:0]       op,
    output reg  [WIDTH-1:0] y,
    output wire             zero,
    output reg              carry,
    output reg              overflow,
    output wire             negative
);

    // Your code here

endmodule
