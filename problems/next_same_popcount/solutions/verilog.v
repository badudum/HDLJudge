module snoob (
    input  wire [15:0] x,
    output wire [15:0] nxt
);
    wire [15:0] s = x & (~x + 16'd1);          // lowest set bit (one-hot)
    wire [16:0] r = {1'b0, x} + {1'b0, s};     // ripple the lowest block of ones
    wire [3:0]  k = {|(s & 16'hFF00), |(s & 16'hF0F0), |(s & 16'hCCCC), |(s & 16'hAAAA)};   // log2(s)
    wire [15:0] t = (x ^ r[15:0]) >> 2;
    wire [15:0] ones = t >> k;                  // divide by s
    assign nxt = (x == 16'd0 || r[16]) ? 16'd0 : (r[15:0] | ones);
endmodule
