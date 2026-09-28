module reset_sync (
    input  wire clk,
    input  wire arst_n,
    output wire rst_n
);
    reg [1:0] s;
    always @(posedge clk or negedge arst_n)
        if (!arst_n) s <= 2'b00;
        else         s <= {s[0], 1'b1};
    assign rst_n = s[1];
endmodule
