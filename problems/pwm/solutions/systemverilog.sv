module pwm8 (
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] duty,
    output logic       pwm_out
);
    logic [7:0] cnt;
    always_ff @(posedge clk) cnt <= rst ? '0 : cnt + 1'b1;
    assign pwm_out = cnt < duty;
endmodule
