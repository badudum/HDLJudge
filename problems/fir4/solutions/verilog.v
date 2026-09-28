module fir4 (
    input  wire              clk,
    input  wire              rst,
    input  wire              valid,
    input  wire signed [7:0] din,
    output reg  signed [11:0] dout
);
    reg signed [7:0] x1, x2, x3;
    wire signed [11:0] a = din, b = x1, c = x2, d = x3;     // sign-extended
    wire signed [11:0] y = a + (b <<< 1) + b + (c <<< 1) + c + d;
    always @(posedge clk) begin
        if (rst) begin
            x1 <= 0; x2 <= 0; x3 <= 0; dout <= 0;
        end else if (valid) begin
            x1 <= din; x2 <= x1; x3 <= x2; dout <= y;
        end
    end
endmodule
