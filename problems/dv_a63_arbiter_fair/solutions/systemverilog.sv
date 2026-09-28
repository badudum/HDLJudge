module chk_arb_fair (
    input logic clk,
    input logic rst,
    input logic [3:0] req,
    input logic [3:0] gnt
);
    a_onehot: assert property (@(posedge clk) disable iff (rst) $onehot0(gnt)) else $error("more than one grant");
    a_reqd:   assert property (@(posedge clk) disable iff (rst) (gnt & ~req) == 4'b0) else $error("grant without request");
    for (genvar i = 0; i < 4; i++) begin : g_fair
        a_fair: assert property (@(posedge clk) disable iff (rst) $past(gnt[i]) && (req & ~(4'b1 << i)) != 4'b0 |-> !gnt[i])
            else $error("master granted twice while others wait");
    end
endmodule
