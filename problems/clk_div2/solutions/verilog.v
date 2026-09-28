module clk_div2 (
    input  wire clk,
    input  wire rst,
    output reg  clk_out
);
    always @(posedge clk)
        if (rst) clk_out <= 1'b0;
        else     clk_out <= ~clk_out;
endmodule
