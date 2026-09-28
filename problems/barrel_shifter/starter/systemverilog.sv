module barrel_shifter #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0]         din,
    input  logic [$clog2(WIDTH)-1:0] shamt,
    input  logic [1:0]               op,
    output logic [WIDTH-1:0]         dout
);

    // Your code here

endmodule
