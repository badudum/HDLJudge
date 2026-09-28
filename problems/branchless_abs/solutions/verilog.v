module babs (
    input  wire [7:0] x,
    output wire [7:0] y
);
    wire [7:0] m = {8{x[7]}};        // all ones if negative
    assign y = (x ^ m) - m;
endmodule
