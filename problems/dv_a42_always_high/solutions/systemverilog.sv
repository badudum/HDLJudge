module chk_pgood (
    input logic clk,
    input logic rst,
    input logic pwr_good
);
    a_never_drops: assert property (@(posedge clk) disable iff (rst) pwr_good |=> pwr_good)
        else $error("pwr_good dropped");
endmodule
