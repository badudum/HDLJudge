module bin2bcd (
    input  logic [7:0]  bin,
    output logic [11:0] bcd
);
    always_comb begin
        logic [19:0] s;
        s = {12'd0, bin};
        for (int i = 0; i < 8; i++) begin
            for (int d = 0; d < 3; d++)
                if (s[8 + 4*d +: 4] >= 5) s[8 + 4*d +: 4] += 4'd3;
            s <<= 1;
        end
        bcd = s[19:8];
    end
endmodule
