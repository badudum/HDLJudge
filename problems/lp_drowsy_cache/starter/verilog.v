module drowsy_array (
    input  wire       clk,
    input  wire       rst,
    input  wire       req,
    input  wire       we,
    input  wire [2:0] idx,
    input  wire [7:0] wdata,
    output reg        ready,
    output reg  [7:0] rdata,
    output reg  [7:0] drowsy,
    output reg  [7:0] wakeups
);

    // Your code here

endmodule
