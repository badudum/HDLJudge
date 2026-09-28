module hyst_comp #(
    parameter real VH = 0.1
) (
    input  real  vp,
    input  real  vn,
    output logic q = 1'b0
);
    always @(vp or vn) begin
        if (vp - vn > VH / 2.0)
            q = 1'b1;
        else if (vp - vn < -VH / 2.0)
            q = 1'b0;
    end
endmodule
