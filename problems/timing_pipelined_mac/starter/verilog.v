// Correct (latency 2) but the second stage is too deep: multiply AND add in one cycle.
module mac2 (
    input  wire        clk,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    input  wire [7:0]  c,
    input  wire [7:0]  d,
    output reg  [16:0] y
);
    reg [7:0] ra, rb, rc, rd;
    always @(posedge clk) begin
        ra <= a; rb <= b; rc <= c; rd <= d;     // stage 1: register inputs
        y  <= ra * rb + rc * rd;                // stage 2: everything else
    end
endmodule
