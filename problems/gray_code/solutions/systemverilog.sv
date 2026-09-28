module gray_conv (
    input  logic [7:0] bin,
    input  logic [7:0] gray_in,
    output logic [7:0] gray,
    output logic [7:0] bin_out
);
    assign gray = bin ^ (bin >> 1);

    always_comb begin
        bin_out[7] = gray_in[7];
        for (int i = 6; i >= 0; i--)
            bin_out[i] = bin_out[i + 1] ^ gray_in[i];
    end
endmodule
