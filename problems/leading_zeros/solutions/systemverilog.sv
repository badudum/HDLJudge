module clz16 (
    input  logic [15:0] x,
    output logic [4:0]  n
);
    // binary search: logarithmic depth
    logic [15:0] v;
    always_comb begin
        v = x;
        if (x == '0) begin
            n = 5'd16;
        end else begin
            n = '0;
            if (v[15:8] == '0) begin n += 8; v = v << 8; end
            if (v[15:12] == '0) begin n += 4; v = v << 4; end
            if (v[15:14] == '0) begin n += 2; v = v << 2; end
            if (v[15] == 1'b0)  begin n += 1; end
        end
    end
endmodule
