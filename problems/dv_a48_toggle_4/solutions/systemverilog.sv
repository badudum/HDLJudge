module chk_toggle (
    input logic clk,
    input logic rst,
    input logic q
);
    a_period: assert property (@(posedge clk) disable iff (rst) $changed(q) |=> $stable(q)[*3] ##1 $changed(q))
        else $error("q did not toggle exactly 4 cycles later");
endmodule
