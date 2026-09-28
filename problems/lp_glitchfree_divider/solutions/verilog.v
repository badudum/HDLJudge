module gf_div (
    input  wire       clk,
    input  wire       rst,
    input  wire [1:0] div,
    output reg        clk_out
);
    reg [1:0] cnt;
    reg [2:0] h;                         // active half period, 1..4

    always @(posedge clk) begin
        if (rst) begin
            clk_out <= 1'b0; cnt <= 2'd0; h <= {1'b0, div} + 3'd1;
        end else if (cnt == h - 3'd1) begin
            cnt     <= 2'd0;
            clk_out <= ~clk_out;
            if (!clk_out) h <= {1'b0, div} + 3'd1;   // new ratio at the rising edge
        end else begin
            cnt <= cnt + 2'd1;
        end
    end
endmodule
