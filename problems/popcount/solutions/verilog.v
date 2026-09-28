module popcount16 (
    input  wire [15:0] x,
    output reg  [4:0]  count
);
    integer i;
    always @(*) begin
        count = 5'd0;
        for (i = 0; i < 16; i = i + 1)
            count = count + {4'd0, x[i]};
    end
endmodule
