module chk_axil_wr (
    input logic clk,
    input logic rst,
    input logic awvalid,
    input logic awready,
    input logic wvalid,
    input logic wready,
    input logic bvalid,
    input logic bready
);
    int aw_pend, w_pend;
    always @(posedge clk) begin
        if (rst) begin
            aw_pend <= 0; w_pend <= 0;
        end else begin
            aw_pend <= aw_pend + (awvalid && awready) - (bvalid && bready);
            w_pend  <= w_pend  + (wvalid && wready)  - (bvalid && bready);
        end
    end
    a_aw: assert property (@(posedge clk) disable iff (rst) awvalid && !awready |=> awvalid) else $error("awvalid dropped");
    a_w:  assert property (@(posedge clk) disable iff (rst) wvalid && !wready |=> wvalid) else $error("wvalid dropped");
    a_b:  assert property (@(posedge clk) disable iff (rst) bvalid && !bready |=> bvalid) else $error("bvalid dropped");
    a_resp: assert property (@(posedge clk) disable iff (rst) bvalid |-> aw_pend > 0 && w_pend > 0)
        else $error("write response without completed address and data");
endmodule
