module rob8 (
    input  wire        clk,
    input  wire        rst,
    input  wire        alloc_valid,
    input  wire [4:0]  alloc_rd,
    input  wire        complete_valid,
    input  wire [2:0]  complete_tag,
    input  wire [15:0] complete_data,
    output reg         alloc_ok,
    output reg  [2:0]  alloc_tag,
    output reg         commit_valid,
    output reg  [4:0]  commit_rd,
    output reg  [15:0] commit_data,
    output reg  [3:0]  count
);

    // Your code here

endmodule
