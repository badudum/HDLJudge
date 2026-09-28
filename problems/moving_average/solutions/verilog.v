module mavg4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       valid_in,
    input  wire [7:0] din,
    output reg  [7:0] dout
);
    reg  [7:0] x1, x2, x3;                        // previous samples
    wire [9:0] sum = din + x1 + x2 + x3;          // window including the new sample

    always @(posedge clk) begin
        if (rst) begin
            x1 <= 8'd0; x2 <= 8'd0; x3 <= 8'd0;
            dout <= 8'd0;
        end else if (valid_in) begin
            x3 <= x2; x2 <= x1; x1 <= din;
            dout <= sum[9:2];
        end
    end
endmodule
