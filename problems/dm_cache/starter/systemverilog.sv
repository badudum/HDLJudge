module dm_cache (
    input  logic       clk,
    input  logic       rst,
    input  logic       rd,
    input  logic       wr,
    input  logic       fill,
    input  logic       inv,
    input  logic [7:0] addr,
    input  logic [7:0] wdata,
    input  logic [7:0] fill_data,
    output logic       hit,
    output logic [7:0] rdata,
    output logic [7:0] hits,
    output logic [7:0] misses
);

    // Your code here

endmodule
