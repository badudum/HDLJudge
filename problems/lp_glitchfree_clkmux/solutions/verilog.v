module clk_mux_gf (
    input  wire clk0,
    input  wire clk1,
    input  wire rst,
    input  wire sel,
    output wire clk_out
);
    reg a1, en0, b1, en1;

    always @(posedge clk0 or posedge rst) if (rst) a1  <= 1'b0; else a1  <= ~sel & ~en1;
    always @(negedge clk0 or posedge rst) if (rst) en0 <= 1'b0; else en0 <= a1;
    always @(posedge clk1 or posedge rst) if (rst) b1  <= 1'b0; else b1  <=  sel & ~en0;
    always @(negedge clk1 or posedge rst) if (rst) en1 <= 1'b0; else en1 <= b1;

    assign clk_out = (clk0 & en0) | (clk1 & en1);
endmodule
