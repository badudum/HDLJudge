module barrel_shifter #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0]         din,
    input  wire [$clog2(WIDTH)-1:0] shamt,
    input  wire [1:0]               op,
    output reg  [WIDTH-1:0]         dout
);

    // Your code here

endmodule
