module max8 (
    input  logic [63:0] x,
    output logic [7:0]  max,
    output logic [2:0]  idx
);
    logic [7:0] v [8];
    logic [2:0] k [8];
    always_comb begin
        for (int i = 0; i < 8; i++) begin
            v[i] = x[8*i +: 8];
            k[i] = 3'(i);
        end
        // three tree levels: width 8 -> 4 -> 2 -> 1
        for (int step = 1; step < 8; step *= 2)
            for (int i = 0; i < 8; i += 2 * step)
                if (v[i + step] > v[i]) begin
                    v[i] = v[i + step];
                    k[i] = k[i + step];
                end
        max = v[0];
        idx = k[0];
    end
endmodule
