module pipe_alu (
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,
    input  logic        valid_in,
    input  logic [1:0]  op,
    input  logic [15:0] a,
    input  logic [15:0] b,
    output logic        valid_out,
    output logic [15:0] y,
    output logic        zero
);

    // Your code here

endmodule
