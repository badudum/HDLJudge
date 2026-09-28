module dm_cache (
    input  wire       clk,
    input  wire       rst,
    input  wire       rd,
    input  wire       wr,
    input  wire       fill,
    input  wire       inv,
    input  wire [7:0] addr,
    input  wire [7:0] wdata,
    input  wire [7:0] fill_data,
    output reg        hit,
    output reg  [7:0] rdata,
    output reg  [7:0] hits,
    output reg  [7:0] misses
);

    // Your code here

endmodule
