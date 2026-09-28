module booth8 (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg        busy,
    output reg        done,
    output reg [15:0] p
);
    reg  [7:0] m, q;
    reg  [8:0] acc;              // 9-bit accumulator: no overflow for -128
    reg        q_1;
    reg  [2:0] n;
    wire [8:0] mx = {m[7], m};
    wire [8:0] sum = (q[0] & ~q_1) ? acc - mx : (~q[0] & q_1) ? acc + mx : acc;

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 1'b0; p <= 16'd0;
        end else if (busy) begin
            {acc, q, q_1} <= {sum[8], sum, q};          // arithmetic shift right
            n <= n + 3'd1;
            if (n == 3'd7) begin
                busy <= 1'b0; done <= 1'b1;
                p <= {sum[8:1], sum[0], q[7:1]};        // {acc, q} after the final shift
            end
        end else if (start) begin
            busy <= 1'b1; m <= a; q <= b; q_1 <= 1'b0; acc <= 9'd0; n <= 3'd0;
        end
    end
endmodule
