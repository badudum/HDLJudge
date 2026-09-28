module chk_outstanding (
    input logic clk,
    input logic rst,
    input logic req,
    input logic rsp
);
    logic [2:0] cnt;
    always @(posedge clk)
        if (rst) cnt <= 3'd0;
        else     cnt <= cnt + {2'd0, req} - {2'd0, rsp};
    a_max: assert property (@(posedge clk) disable iff (rst) req && !rsp |-> cnt < 2) else $error("more than 2 outstanding");
    a_rsp: assert property (@(posedge clk) disable iff (rst) rsp |-> cnt > 0) else $error("response without outstanding request");
endmodule
