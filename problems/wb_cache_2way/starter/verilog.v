module wb_cache (
    input  wire       clk,
    input  wire       rst,
    input  wire       req,
    input  wire       we,
    input  wire [5:0] addr,
    input  wire [7:0] wdata,
    input  wire [7:0] mem_rdata,
    output reg        hit,
    output reg  [7:0] rdata,
    output reg        wb_valid,
    output reg  [5:0] wb_addr,
    output reg  [7:0] wb_data
);

    // Your code here

endmodule
