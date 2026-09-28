module sync_fifo (
    input  wire       clk,
    input  wire       rst,
    input  wire       wr_en,
    input  wire [7:0] din,
    input  wire       rd_en,
    output reg  [7:0] dout,
    output wire       full,
    output wire       empty,
    output wire [3:0] count
);

    // Your code here

endmodule
