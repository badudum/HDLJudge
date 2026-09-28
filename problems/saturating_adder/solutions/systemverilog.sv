module sat_add8 (
    input  logic signed [7:0] a,
    input  logic signed [7:0] b,
    output logic signed [7:0] sum,
    output logic              ovf
);
    logic signed [8:0] s;
    always_comb begin
        s = a + b;                  // 9-bit context: sign-extended, exact
        ovf = (s > 127) || (s < -128);
        if (s > 127)       sum = 8'sd127;
        else if (s < -128) sum = -8'sd128;
        else               sum = s[7:0];
    end
endmodule
