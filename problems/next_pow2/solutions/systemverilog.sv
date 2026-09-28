module next_pow2 (
    input  logic [15:0] x,
    output logic [16:0] y
);
    logic [15:0] v;
    always_comb begin
        v = x - 1'b1;
        v |= v >> 1;
        v |= v >> 2;
        v |= v >> 4;
        v |= v >> 8;
        y = (x == '0) ? 17'd1 : 17'(v) + 17'd1;
    end
endmodule
