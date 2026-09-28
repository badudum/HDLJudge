module wb_cache (
    input  logic       clk,
    input  logic       rst,
    input  logic       req,
    input  logic       we,
    input  logic [5:0] addr,
    input  logic [7:0] wdata,
    input  logic [7:0] mem_rdata,
    output logic       hit,
    output logic [7:0] rdata,
    output logic       wb_valid,
    output logic [5:0] wb_addr,
    output logic [7:0] wb_data
);

    // Your code here

endmodule
