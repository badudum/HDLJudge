module chk_overlap (
    input logic clk,
    input logic rst,
    input logic gnt_a,
    input logic gnt_b
);
    a_mutex: assert property (@(posedge clk) disable iff (rst) !(gnt_a && gnt_b))
        else $error("grants overlap");
    a_gap_ab: assert property (@(posedge clk) disable iff (rst) $fell(gnt_a) |-> !gnt_b)
        else $error("no idle cycle between gnt_a and gnt_b");
    a_gap_ba: assert property (@(posedge clk) disable iff (rst) $fell(gnt_b) |-> !gnt_a)
        else $error("no idle cycle between gnt_b and gnt_a");
endmodule
