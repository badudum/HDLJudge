module therm2bin (
    input  logic [14:0] t,
    output logic [3:0]  count,
    output logic        err
);
    always_comb begin
        count = '0;
        for (int i = 0; i < 15; i++)
            if (t[i]) count = 4'(i + 1);
        // valid codes are 2^k - 1: no 0 may appear below the highest 1
        err = 1'b0;
        for (int i = 0; i < 14; i++)
            if (t[i + 1] && !t[i]) err = 1'b1;
    end
endmodule
