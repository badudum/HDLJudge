module chk_fifo (
    input logic clk,
    input logic rst,
    input logic push,
    input logic pop,
    input logic full,
    input logic empty,
    input logic [3:0] count
);
    wire do_push = push && !full;
    wire do_pop  = pop && !empty;
    a_full:  assert property (@(posedge clk) disable iff (rst) full == (count == 4'd8)) else $error("full flag wrong");
    a_empty: assert property (@(posedge clk) disable iff (rst) empty == (count == 4'd0)) else $error("empty flag wrong");
    a_inc:   assert property (@(posedge clk) disable iff (rst) do_push && !do_pop |=> count == $past(count) + 4'd1) else $error("count did not increment");
    a_dec:   assert property (@(posedge clk) disable iff (rst) do_pop && !do_push |=> count == $past(count) - 4'd1) else $error("count did not decrement");
    a_hold:  assert property (@(posedge clk) disable iff (rst) do_push == do_pop |=> count == $past(count)) else $error("count changed unexpectedly");
endmodule
