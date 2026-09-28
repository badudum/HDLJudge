module clz16 (
    input  wire [15:0] x,
    output reg  [4:0]  n
);
    integer i;
    always @(*) begin
        n = 5'd16;
        for (i = 0; i < 16; i = i + 1)
            if (x[i]) n = 15 - i;
    end
endmodule
