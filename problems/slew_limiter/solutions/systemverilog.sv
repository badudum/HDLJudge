module slew_limiter #(
    parameter real SR = 1.0e7,
    parameter real TS = 10.0e-9
) (
    input  logic clk,
    input  real  vin,
    output real  vout = 0.0
);
    localparam real STEP = SR * TS;
    real d;

    always @(posedge clk) begin
        d = vin - vout;
        if (d > STEP)       d = STEP;
        else if (d < -STEP) d = -STEP;
        vout <= vout + d;
    end
endmodule
