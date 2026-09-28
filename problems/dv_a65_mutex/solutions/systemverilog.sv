module chk_lock (
    input logic clk,
    input logic rst,
    input logic [2:0] lock_req,
    input logic [2:0] lock_gnt
);
    a_one:  assert property (@(posedge clk) disable iff (rst) $onehot0(lock_gnt)) else $error("two lock owners");
    for (genvar i = 0; i < 3; i++) begin : g_req
        a_req: assert property (@(posedge clk) disable iff (rst) $rose(lock_gnt[i]) |-> lock_req[i]) else $error("lock granted to non-requester");
    end
    for (genvar i = 0; i < 3; i++) begin : g_keep
        a_keep: assert property (@(posedge clk) disable iff (rst) lock_gnt[i] && lock_req[i] |=> lock_gnt[i])
            else $error("lock revoked while still requested");
    end
endmodule
