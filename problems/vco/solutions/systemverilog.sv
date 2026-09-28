`timescale 1ns / 1ps
module vco #(
    parameter real F0   = 100.0e6,
    parameter real KVCO = 50.0e6
) (
    input  real  vctrl,
    output logic clk_out = 1'b0
);
    real f;
    always begin
        f = F0 + KVCO * vctrl;
        if (f < 1.0e6) f = 1.0e6;
        if (f > 1.0e9) f = 1.0e9;
        #(0.5e9 / f) clk_out = ~clk_out;      // half period in ns
    end
endmodule
