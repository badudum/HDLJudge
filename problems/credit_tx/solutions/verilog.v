module credit_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] in_data,
    output wire       in_ready,
    output reg        tx_valid,
    output reg  [7:0] tx_data,
    input  wire       credit_ret,
    output reg  [2:0] credits
);
    assign in_ready = (credits != 3'd0);
    wire send = in_valid && in_ready;
    always @(posedge clk) begin
        if (rst) begin
            credits <= 3'd4; tx_valid <= 1'b0;
        end else begin
            tx_valid <= send;
            if (send) tx_data <= in_data;
            credits <= credits - {2'd0, send} + {2'd0, credit_ret};
        end
    end
endmodule
