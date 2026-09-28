module div_by_3 (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire div
);
    // state = value mod 3; next = (2*state + din) mod 3
    reg [1:0] rem;
    always @(posedge clk) begin
        if (rst) rem <= 2'd0;
        else case ({rem, din})
            3'b00_0: rem <= 2'd0;
            3'b00_1: rem <= 2'd1;
            3'b01_0: rem <= 2'd2;
            3'b01_1: rem <= 2'd0;
            3'b10_0: rem <= 2'd1;
            3'b10_1: rem <= 2'd2;
            default: rem <= 2'd0;
        endcase
    end
    assign div = (rem == 2'd0);
endmodule
