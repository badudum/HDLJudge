module debounce (
    input  wire clk,
    input  wire rst,
    input  wire btn,
    output reg  clean
);
    reg [1:0] cnt;
    always @(posedge clk) begin
        if (rst) begin
            clean <= 1'b0;
            cnt <= 2'd0;
        end else if (btn != clean) begin
            if (cnt == 2'd3) begin
                clean <= btn;
                cnt <= 2'd0;
            end else begin
                cnt <= cnt + 2'd1;
            end
        end else begin
            cnt <= 2'd0;
        end
    end
endmodule
