// Correct (latency 2) but the second stage is too deep: multiply AND add in one cycle.
module mac2 (
    input  logic        clk,
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    input  logic [7:0]  c,
    input  logic [7:0]  d,
    output logic [16:0] y
);
    logic [7:0] ra, rb, rc, rd;
    always_ff @(posedge clk) begin
        {ra, rb, rc, rd} <= {a, b, c, d};         // stage 1: register inputs
        y <= ra * rb + rc * rd;                   // stage 2: everything else
    end
endmodule
