module sdiv3l (
    input  wire clk,
    input  wire rst,
    input  wire valid,
    input  wire bit_in,
    output wire d3
);
    reg [1:0] r;          // remainder so far
    reg       w2;         // next bit has weight 2 (mod 3)
    reg [2:0] t;          // r + weight: up to 4, needs 3 bits
    reg [1:0] s;
    always @(*) begin
        t = {1'b0, r} + (bit_in ? (w2 ? 3'd2 : 3'd1) : 3'd0);
        s = (t >= 3'd3) ? t - 3'd3 : t[1:0];
    end
    always @(posedge clk)
        if (rst)        begin r <= 2'd0; w2 <= 1'b0; end
        else if (valid) begin r <= s;    w2 <= ~w2;  end
    assign d3 = (r == 2'd0);
endmodule
