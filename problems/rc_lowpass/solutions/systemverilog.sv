module rc_lpf #(
    parameter real TAU = 1.0e-6,
    parameter real TS  = 10.0e-9
) (
    input  logic clk,
    input  real  vin,
    output real  vout = 0.0
);
    localparam real ALPHA = 1.0 - $exp(-TS / TAU);

    always @(posedge clk)
        vout <= vout + (vin - vout) * ALPHA;
endmodule
