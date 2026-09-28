module clk_div3 (
    input  wire clk,
    input  wire rst,
    output wire clk_out
);
    reg [1:0] cnt;
    reg       p, n;

    always @(posedge clk) begin
        if (rst) begin
            cnt <= 2'd0; p <= 1'b0;
        end else begin
            cnt <= (cnt == 2'd2) ? 2'd0 : cnt + 2'd1;
            p   <= (cnt == 2'd2);          // high for one of every three cycles
        end
    end

    always @(negedge clk)                   // half-cycle delayed copy
        if (rst) n <= 1'b0;
        else     n <= p;

    assign clk_out = p | n;                 // 1.5 cycles high, no glitch
endmodule
