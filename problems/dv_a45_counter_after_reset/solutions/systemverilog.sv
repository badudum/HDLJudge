module chk_counter (
    input logic clk,
    input logic rst,
    input logic en,
    input logic [3:0] count
);
    a_zero_after_reset: assert property (@(posedge clk) $fell(rst) |-> count == 4'd0)
        else $error("count not zero after reset");
    a_hold: assert property (@(posedge clk) disable iff (rst) !en |=> $stable(count))
        else $error("count changed while disabled");
    a_inc: assert property (@(posedge clk) disable iff (rst) en |=> count == $past(count) + 4'd1)
        else $error("count did not increment by one");
endmodule
