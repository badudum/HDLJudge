module nand_fa (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire t1, u1, v1, x1, t2, u2, v2;
    // x1 = a ^ b
    nand g1 (t1, a, b);
    nand g2 (u1, a, t1);
    nand g3 (v1, b, t1);
    nand g4 (x1, u1, v1);
    // sum = x1 ^ cin
    nand g5 (t2, x1, cin);
    nand g6 (u2, x1, t2);
    nand g7 (v2, cin, t2);
    nand g8 (sum, u2, v2);
    // cout = a&b | x1&cin
    nand g9 (cout, t1, t2);
endmodule
