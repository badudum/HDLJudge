module drowsy_array (
    input  logic       clk,
    input  logic       rst,
    input  logic       req,
    input  logic       we,
    input  logic [2:0] idx,
    input  logic [7:0] wdata,
    output logic       ready,
    output logic [7:0] rdata,
    output logic [7:0] drowsy,
    output logic [7:0] wakeups
);

    // Your code here

endmodule
