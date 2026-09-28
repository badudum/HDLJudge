module secded_dec (
    input  logic [7:0] code,
    output logic [3:0] data,
    output logic       single_err,
    output logic       double_err
);
    logic [7:0] fixed;
    logic [2:0] syn;
    logic       parity;

    always_comb begin
        syn[0] = code[0] ^ code[2] ^ code[4] ^ code[6];
        syn[1] = code[1] ^ code[2] ^ code[5] ^ code[6];
        syn[2] = code[3] ^ code[4] ^ code[5] ^ code[6];
        parity = ^code;
        fixed  = code;
        if (parity && syn != 0)
            fixed[syn - 1] = ~code[syn - 1];     // Hamming position syn is code bit syn-1
        single_err = parity;
        double_err = !parity && syn != 0;
        data = {fixed[6], fixed[5], fixed[4], fixed[2]};
    end
endmodule
