module debounce (
    input  logic clk,
    input  logic rst,
    input  logic btn,
    output logic clean
);
    localparam int N = 4;
    logic [$clog2(N)-1:0] cnt;
    always_ff @(posedge clk) begin
        if (rst) begin
            clean <= 1'b0;
            cnt <= '0;
        end else if (btn == clean) begin
            cnt <= '0;
        end else if (cnt == N - 1) begin
            clean <= btn;
            cnt <= '0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
endmodule
