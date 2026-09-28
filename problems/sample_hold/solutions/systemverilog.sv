module sample_hold #(
    parameter real DROOP = 0.999
) (
    input  logic clk,
    input  logic track,
    input  real  vin,
    output real  vout = 0.0
);
    always @(posedge clk)
        vout <= track ? vin : vout * DROOP;
endmodule
