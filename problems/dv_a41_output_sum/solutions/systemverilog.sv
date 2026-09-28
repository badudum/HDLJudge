module chk_sum (
    input logic clk,
    input logic rst,
    input logic [7:0] a,
    input logic [7:0] b,
    input logic [8:0] y
);
    a_sum: assert property (@(posedge clk) disable iff (rst) 1'b1 |=> y == $past(9'(a) + 9'(b)))
        else $error("y is not the registered sum");
endmodule
