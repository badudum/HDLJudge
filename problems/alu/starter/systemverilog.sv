module alu #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [3:0]       op,
    output logic [WIDTH-1:0] y,
    output logic             zero,
    output logic             carry,
    output logic             overflow,
    output logic             negative
);

    // Your code here

endmodule
