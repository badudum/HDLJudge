module mac2 (
    input  logic        clk,
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    input  logic [7:0]  c,
    input  logic [7:0]  d,
    output logic [16:0] y
);
    logic [15:0] p1, p2;
    always_ff @(posedge clk) begin
        p1 <= a * b;
        p2 <= c * d;
        y  <= 17'(p1) + 17'(p2);
    end
endmodule
