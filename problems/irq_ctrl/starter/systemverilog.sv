module irq_ctrl (
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] irq_in,
    input  logic       mask_we,
    input  logic [7:0] mask_data,
    input  logic       ack,
    output logic       irq,
    output logic [2:0] id,
    output logic [7:0] pending,
    output logic [7:0] mask
);

    // Your code here

endmodule
