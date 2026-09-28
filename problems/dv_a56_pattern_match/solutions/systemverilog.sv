module chk_sync (
    input logic clk,
    input logic rst,
    input logic din,
    input logic lock
);
    a_lock: assert property (@(posedge clk) disable iff (rst) din ##1 din ##1 !din ##1 din |=> lock)
        else $error("lock missing after sync pattern");
endmodule
