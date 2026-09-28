module gray_inc (
    input  wire [7:0] g,
    output wire [7:0] gn
);
    wire [7:0] t1 = g  ^ (g  >> 1);
    wire [7:0] t2 = t1 ^ (t1 >> 2);
    wire [7:0] b  = t2 ^ (t2 >> 4);      // Gray -> binary (prefix XOR)
    wire [7:0] n  = b + 8'd1;
    assign gn = n ^ (n >> 1);            // binary -> Gray
endmodule
