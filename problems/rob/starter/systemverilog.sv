module rob8 (
    input  logic        clk,
    input  logic        rst,
    input  logic        alloc_valid,
    input  logic [4:0]  alloc_rd,
    input  logic        complete_valid,
    input  logic [2:0]  complete_tag,
    input  logic [15:0] complete_data,
    output logic        alloc_ok,
    output logic [2:0]  alloc_tag,
    output logic        commit_valid,
    output logic [4:0]  commit_rd,
    output logic [15:0] commit_data,
    output logic [3:0]  count
);

    // Your code here

endmodule
