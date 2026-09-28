module level_shifter (
    input  real vin,
    input  real vddl,
    input  real vddh,
    output real vout
);
    bit state = 1'b0;
    always @(vin or vddl or vddh) begin
        if (vddl < 0.3)            state = 1'b0;
        else if (vin > 0.6 * vddl) state = 1'b1;
        else if (vin < 0.4 * vddl) state = 1'b0;
        vout = (state && vddl >= 0.3) ? vddh : 0.0;
    end
endmodule
