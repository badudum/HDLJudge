module pipe_alu (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        valid_in,
    input  wire [1:0]  op,
    input  wire [15:0] a,
    input  wire [15:0] b,
    output reg         valid_out,
    output reg  [15:0] y,
    output reg         zero
);

    // Your code here

endmodule
