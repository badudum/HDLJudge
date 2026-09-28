module rc_lpf #(
    parameter real TAU = 1.0e-6,     // time constant [s]
    parameter real TS  = 10.0e-9     // update step (clock period) [s]
) (
    input  logic clk,
    input  real  vin,
    output real  vout = 0.0
);

    // Your code here

endmodule
