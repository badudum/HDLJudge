module smul8 (
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [15:0] p
);
    wire [15:0] ax = {{8{a[7]}}, a};        // sign-extended multiplicand
    integer i;
    always @(*) begin
        p = 16'd0;
        for (i = 0; i < 7; i = i + 1)
            if (b[i]) p = p + (ax << i);
        if (b[7]) p = p - (ax << 7);          // bit 7 of b weighs -128
    end
endmodule
