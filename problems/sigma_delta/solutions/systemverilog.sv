module sd_mod1 (
    input  logic clk,
    input  logic rst,
    input  real  vin,
    output logic bit_out
);
    real integ;

    always @(posedge clk) begin
        if (rst) begin
            integ   = 0.0;
            bit_out <= 1'b0;
        end else begin
            integ   = integ + vin - (bit_out ? 1.0 : -1.0);
            bit_out <= (integ >= 0.0);
        end
    end
endmodule
