module cdc_handshake (
    input  logic       clk_a,
    input  logic       rst_a,
    input  logic       a_valid,
    input  logic [7:0] a_data,
    output logic       a_ready,
    input  logic       clk_b,
    input  logic       rst_b,
    output logic       b_valid,
    output logic [7:0] b_data
);

    // Your code here

endmodule
