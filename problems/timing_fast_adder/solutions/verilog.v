module fast_add16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        cin,
    output wire [15:0] s,
    output wire        cout
);
    // Kogge-Stone parallel-prefix carry network (log2(16) = 4 levels)
    wire [15:0] g0 = a & b;
    wire [15:0] p0 = a ^ b;
    wire [15:0] g1, p1, g2, p2, g3, p3, g4;

    // cin is folded into bit 0's generate
    wire [15:0] gi = {g0[15:1], g0[0] | (p0[0] & cin)};

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pre
            if (i >= 1) begin
                assign g1[i] = gi[i] | (p0[i] & gi[i-1]);
                assign p1[i] = p0[i] & p0[i-1];
            end else begin
                assign g1[i] = gi[i];
                assign p1[i] = p0[i];
            end
            if (i >= 2) begin
                assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
                assign p2[i] = p1[i] & p1[i-2];
            end else begin
                assign g2[i] = g1[i];
                assign p2[i] = p1[i];
            end
            if (i >= 4) begin
                assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
                assign p3[i] = p2[i] & p2[i-4];
            end else begin
                assign g3[i] = g2[i];
                assign p3[i] = p2[i];
            end
            if (i >= 8) assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
            else        assign g4[i] = g3[i];
        end
    endgenerate

    // carry into bit i is the group generate of bits i-1..0 (with cin)
    assign s    = p0 ^ {g4[14:0], cin};
    assign cout = g4[15];
endmodule
