module runs (
    input  wire [15:0] x,
    output wire        run3,
    output wire [15:0] alone
);
    assign run3  = |(x & (x >> 1) & (x >> 2));
    assign alone = x & ~(x << 1) & ~(x >> 1);
endmodule
