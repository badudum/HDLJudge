module clk_div_n #(
    parameter N = 5
) (
    input  wire clk,
    input  wire rst,
    output reg  clk_out
);
    reg [3:0] cnt;
    wire [3:0] nxt = (cnt == N - 1) ? 4'd0 : cnt + 4'd1;

    always @(posedge clk) begin
        if (rst) begin
            cnt <= 4'd0; clk_out <= 1'b0;
        end else begin
            cnt     <= nxt;
            clk_out <= (nxt < N / 2);
        end
    end
endmodule
