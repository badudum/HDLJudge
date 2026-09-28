module adc8 #(
    parameter real VREF = 1.0
) (
    input  logic       clk,
    input  real        vin,
    output logic [7:0] code = 8'd0
);
    real x;
    always @(posedge clk) begin
        x = $floor(vin / VREF * 256.0);
        if (x < 0.0)        code <= 8'd0;
        else if (x > 255.0) code <= 8'd255;
        else                code <= $rtoi(x);
    end
endmodule
