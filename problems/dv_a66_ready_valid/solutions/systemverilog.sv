module chk_rv (
    input logic clk,
    input logic rst,
    input logic valid,
    input logic ready,
    input logic [7:0] data
);
    a_hold: assert property (@(posedge clk) disable iff (rst) valid && !ready |=> valid && $stable(data))
        else $error("valid/data not held until ready");
endmodule
