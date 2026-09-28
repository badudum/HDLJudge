module chk_starve (
    input logic clk,
    input logic rst,
    input logic [3:0] req,
    input logic [3:0] gnt
);
    for (genvar i = 0; i < 4; i++) begin : g_live
        a_live: assert property (@(posedge clk) disable iff (rst) $rose(req[i]) |-> ##[0:4] gnt[i])
            else $error("request not granted within 4 cycles");
    end
endmodule
