module pwm8 (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] duty,
    output wire       pwm_out
);
    reg [7:0] cnt;
    always @(posedge clk) begin
        if (rst) cnt <= 8'd0;
        else     cnt <= cnt + 8'd1;
    end
    assign pwm_out = (cnt < duty);
endmodule
