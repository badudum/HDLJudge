module chk_fsm (
    input logic clk,
    input logic rst,
    input logic [1:0] state
);
    a_idle: assert property (@(posedge clk) disable iff (rst) state == 2'd0 |=> state inside {2'd0, 2'd1}) else $error("illegal from IDLE");
    a_req:  assert property (@(posedge clk) disable iff (rst) state == 2'd1 |=> state inside {2'd0, 2'd1, 2'd2}) else $error("illegal from REQ");
    a_xfer: assert property (@(posedge clk) disable iff (rst) state == 2'd2 |=> state == 2'd3) else $error("illegal from XFER");
    a_done: assert property (@(posedge clk) disable iff (rst) state == 2'd3 |=> state inside {2'd3, 2'd0}) else $error("illegal from DONE");
endmodule
