module mac2 (
    input  wire        clk,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    input  wire [7:0]  c,
    input  wire [7:0]  d,
    output reg  [16:0] y
);
    reg [15:0] p1, p2;
    always @(posedge clk) begin
        p1 <= a * b;             // stage 1: the multipliers
        p2 <= c * d;
        y  <= p1 + p2;           // stage 2: the adder
    end
endmodule
