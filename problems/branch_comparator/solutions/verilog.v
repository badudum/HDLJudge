module branch_cmp (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  funct3,
    output reg         taken
);
    wire eq  = (a == b);
    wire ltu = (a < b);
    wire lt  = (a[31] != b[31]) ? a[31] : ltu;

    always @(*) begin
        case (funct3)
            3'b000:  taken = eq;
            3'b001:  taken = !eq;
            3'b100:  taken = lt;
            3'b101:  taken = !lt;
            3'b110:  taken = ltu;
            3'b111:  taken = !ltu;
            default: taken = 1'b0;
        endcase
    end
endmodule
