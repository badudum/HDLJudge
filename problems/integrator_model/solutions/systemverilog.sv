module integrator #(
    parameter real K = 0.1
) (
    input  logic clk,
    input  logic rst,
    input  real  x,
    output real  y = 0.0
);
    real t;
    always @(posedge clk) begin
        if (rst) y <= 0.0;
        else begin
            t = y + K * x;
            y <= (t > 1.0) ? 1.0 : (t < -1.0) ? -1.0 : t;
        end
    end
endmodule
