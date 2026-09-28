module scoreboard (
    input  logic       clk,
    input  logic       rst,
    input  logic       issue_valid,
    input  logic [2:0] rd,
    input  logic [2:0] rs1,
    input  logic [2:0] rs2,
    input  logic       wb_valid,
    input  logic [2:0] wb_rd,
    output logic       issued,
    output logic [7:0] pending
);

    // Your code here

endmodule
