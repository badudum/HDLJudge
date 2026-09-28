module cb_bist (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [7:0] mem_rdata,
    output reg  [3:0] mem_addr,
    output reg        mem_we,
    output reg  [7:0] mem_wdata,
    output reg        busy,
    output reg        done,
    output reg        fail
);

    // Your code here

endmodule
