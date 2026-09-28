module nand_mux (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    wire sn, t0, t1;
    nand g0 (sn, sel, sel);     // inverter
    nand g1 (t0, a, sn);
    nand g2 (t1, b, sel);
    nand g3 (y, t0, t1);
endmodule
