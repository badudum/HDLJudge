module penc32 (
    input  wire [31:0] req,
    output wire        valid,
    output wire [4:0]  idx
);
    // level 0: pairs of bits
    wire [15:0] v1;  wire [15:0] i1;            // 1-bit index per pair
    wire [7:0]  v2;  wire [15:0] i2;            // 2-bit index per quad
    wire [3:0]  v3;  wire [11:0] i3;            // 3-bit index per octet
    wire [1:0]  v4;  wire [7:0]  i4;            // 4-bit index per half
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : l1
            assign v1[k] = req[2*k] | req[2*k+1];
            assign i1[k] = ~req[2*k];
        end
        for (k = 0; k < 8; k = k + 1) begin : l2
            assign v2[k] = v1[2*k] | v1[2*k+1];
            assign i2[2*k +: 2] = v1[2*k] ? {1'b0, i1[2*k]} : {1'b1, i1[2*k+1]};
        end
        for (k = 0; k < 4; k = k + 1) begin : l3
            assign v3[k] = v2[2*k] | v2[2*k+1];
            assign i3[3*k +: 3] = v2[2*k] ? {1'b0, i2[4*k +: 2]} : {1'b1, i2[4*k+2 +: 2]};
        end
        for (k = 0; k < 2; k = k + 1) begin : l4
            assign v4[k] = v3[2*k] | v3[2*k+1];
            assign i4[4*k +: 4] = v3[2*k] ? {1'b0, i3[6*k +: 3]} : {1'b1, i3[6*k+3 +: 3]};
        end
    endgenerate
    assign valid = v4[0] | v4[1];
    assign idx   = !valid ? 5'd0 : v4[0] ? {1'b0, i4[3:0]} : {1'b1, i4[7:4]};
endmodule
