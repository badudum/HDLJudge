module credit_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] in_data,
    output reg        in_ready,
    output reg        tx_valid,
    output reg  [7:0] tx_data,
    input  wire       credit_ret,
    output reg  [2:0] credits
);

    // Your code here

endmodule
