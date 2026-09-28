module chk_fifo (
    input logic clk,
    input logic rst,
    input logic push,
    input logic pop,
    input logic full,
    input logic empty
);
    a_overflow:  assert property (@(posedge clk) disable iff (rst) push && full |-> pop) else $error("push while full");
    a_underflow: assert property (@(posedge clk) disable iff (rst) pop |-> !empty) else $error("pop while empty");
endmodule
