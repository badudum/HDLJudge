module cdc_handshake (
    input  wire       clk_a,
    input  wire       rst_a,
    input  wire       a_valid,
    input  wire [7:0] a_data,
    output reg        a_ready,
    input  wire       clk_b,
    input  wire       rst_b,
    output reg        b_valid,
    output reg  [7:0] b_data
);

    // Your code here

endmodule
