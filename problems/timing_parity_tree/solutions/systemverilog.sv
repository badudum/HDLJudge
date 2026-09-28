module parity64 (
    input  logic [63:0] d,
    output logic        p
);
    // explicit pairwise tree
    logic [31:0] l1;
    logic [15:0] l2;
    logic [7:0]  l3;
    logic [3:0]  l4;
    logic [1:0]  l5;
    always_comb begin
        for (int i = 0; i < 32; i++) l1[i] = d[2*i] ^ d[2*i+1];
        for (int i = 0; i < 16; i++) l2[i] = l1[2*i] ^ l1[2*i+1];
        for (int i = 0; i < 8; i++)  l3[i] = l2[2*i] ^ l2[2*i+1];
        for (int i = 0; i < 4; i++)  l4[i] = l3[2*i] ^ l3[2*i+1];
        for (int i = 0; i < 2; i++)  l5[i] = l4[2*i] ^ l4[2*i+1];
        p = l5[0] ^ l5[1];
    end
endmodule
