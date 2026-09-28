module hs_sva (
    input logic       clk,
    input logic       rst,
    input logic       req,
    input logic       gnt,
    input logic [3:0] id
);
    int cov_b2b = 0, cov_max_wait = 0;

    a_gnt_req: assert property (@(posedge clk) disable iff (rst) gnt |-> req)
        else `uvm_error("HS_GNT_NO_REQ", "gnt asserted without req")

    a_req_hold: assert property (@(posedge clk) disable iff (rst) req && !gnt |=> req)
        else `uvm_error("HS_REQ_DROP", "req dropped before gnt")

    a_id_stable: assert property (@(posedge clk) disable iff (rst) req && !gnt |=> $stable(id))
        else `uvm_error("HS_ID_CHANGE", "id changed while waiting for gnt")

    a_timeout: assert property (@(posedge clk) disable iff (rst) $rose(req) |-> ##[1:4] gnt)
        else `uvm_error("HS_TIMEOUT", "no gnt within 4 cycles of req")

    c_b2b: cover property (@(posedge clk) disable iff (rst) gnt ##1 gnt)
        cov_b2b++;

    c_max_wait: cover property (@(posedge clk) disable iff (rst) $rose(req) ##4 gnt)
        cov_max_wait++;
endmodule
