module max8 (
    input  wire [63:0] x,
    output wire [7:0]  max,
    output wire [2:0]  idx
);
    // one tournament node: keeps the left operand on ties
    function [10:0] pick(input [10:0] l, input [10:0] r);   // {idx, value}
        pick = (r[7:0] > l[7:0]) ? r : l;
    endfunction

    wire [10:0] a0 = pick({3'd0, x[7:0]},   {3'd1, x[15:8]});
    wire [10:0] a1 = pick({3'd2, x[23:16]}, {3'd3, x[31:24]});
    wire [10:0] a2 = pick({3'd4, x[39:32]}, {3'd5, x[47:40]});
    wire [10:0] a3 = pick({3'd6, x[55:48]}, {3'd7, x[63:56]});
    wire [10:0] b0 = pick(a0, a1);
    wire [10:0] b1 = pick(a2, a3);
    wire [10:0] c0 = pick(b0, b1);

    assign max = c0[7:0];
    assign idx = c0[10:8];
endmodule
