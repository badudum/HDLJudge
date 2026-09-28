module gcd16 (
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic [15:0] a,
    input  logic [15:0] b,
    output logic        busy,
    output logic        done,
    output logic [15:0] result
);
    // Stein's binary GCD: gcd(u, v) = 2^k * gcd of the odd parts
    logic [15:0] u, v;
    logic [4:0]  k;

    always_ff @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy   <= 1'b0;
            result <= '0;
        end else if (!busy) begin
            if (start) begin
                u    <= a;
                v    <= b;
                k    <= '0;
                busy <= 1'b1;
            end
        end else if (u == 0 || v == 0) begin
            result <= (u | v) << k;
            done   <= 1'b1;
            busy   <= 1'b0;
        end else if (!u[0] && !v[0]) begin
            u <= u >> 1; v <= v >> 1; k <= k + 1'b1;
        end else if (!u[0]) begin
            u <= u >> 1;
        end else if (!v[0]) begin
            v <= v >> 1;
        end else if (u >= v) begin
            u <= (u - v) >> 1;
        end else begin
            v <= (v - u) >> 1;
        end
    end
endmodule
