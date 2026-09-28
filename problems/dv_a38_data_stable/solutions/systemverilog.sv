module chk_stable (
    input logic clk,
    input logic rst,
    input logic valid,
    input logic ready,
    input logic [7:0] data
);
    a_stable: assert property (@(posedge clk) disable iff (rst) valid && !ready |=> $stable(data))
        else $error("data changed while valid was stalled");
endmodule
