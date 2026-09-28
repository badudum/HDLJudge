module gray_conv (
    input  wire [7:0] bin,
    input  wire [7:0] gray_in,
    output wire [7:0] gray,
    output reg  [7:0] bin_out
);
    integer i;

    assign gray = bin ^ (bin >> 1);

    always @(*) begin
        for (i = 0; i < 8; i = i + 1)
            bin_out[i] = ^(gray_in >> i);
    end
endmodule
