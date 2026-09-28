module scoreboard (
    input  wire       clk,
    input  wire       rst,
    input  wire       issue_valid,
    input  wire [2:0] rd,
    input  wire [2:0] rs1,
    input  wire [2:0] rs2,
    input  wire       wb_valid,
    input  wire [2:0] wb_rd,
    output reg        issued,
    output reg  [7:0] pending
);

    // Your code here

endmodule
