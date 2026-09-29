module diff_amp #(
    parameter real GAIN = 1.0,
    parameter real VSAT = 1.0
) (
    input  logic  clk,
    input  real   vp,
    input  real   vn,
    output real   vout = 0.0
);

    always_ff @(posedge clk) begin
        real raw;
        raw = GAIN * (vp - vn);
        if (raw > VSAT)
            vout <= VSAT;
        else if (raw < -VSAT)
            vout <= -VSAT;
        else
            vout <= raw;
    end

endmodule
