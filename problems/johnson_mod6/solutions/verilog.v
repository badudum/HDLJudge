module johnson6 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [2:0] q,
    output wire       tick
);
    always @(posedge clk)
        if (rst)     q <= 3'b000;
        else if (en) q <= {q[1:0], ~q[2]};
    assign tick = q[2] & ~q[1];
endmodule
