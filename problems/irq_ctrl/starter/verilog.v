module irq_ctrl (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] irq_in,
    input  wire       mask_we,
    input  wire [7:0] mask_data,
    input  wire       ack,
    output reg        irq,
    output reg  [2:0] id,
    output reg  [7:0] pending,
    output reg  [7:0] mask
);

    // Your code here

endmodule
