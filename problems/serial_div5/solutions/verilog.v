module sdiv5 (
    input  wire clk,
    input  wire rst,
    input  wire valid,
    input  wire bit_in,
    output wire d5
);
    reg [2:0] r;                       // running remainder mod 5
    reg [2:0] nxt;
    always @(*) begin
        case ({r, bit_in})
            4'b000_0: nxt = 3'd0;  4'b000_1: nxt = 3'd1;
            4'b001_0: nxt = 3'd2;  4'b001_1: nxt = 3'd3;
            4'b010_0: nxt = 3'd4;  4'b010_1: nxt = 3'd0;
            4'b011_0: nxt = 3'd1;  4'b011_1: nxt = 3'd2;
            4'b100_0: nxt = 3'd3;  4'b100_1: nxt = 3'd4;
            default:  nxt = 3'd0;
        endcase
    end
    always @(posedge clk)
        if (rst)        r <= 3'd0;
        else if (valid) r <= nxt;
    assign d5 = (r == 3'd0);
endmodule
