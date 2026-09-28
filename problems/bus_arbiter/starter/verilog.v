module bus_arb (
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] req,
    input  wire [2:0] lock,
    output reg  [2:0] gnt,
    output reg  [1:0] owner,
    output reg        busy
);

    // Your code here

endmodule
