module chk_freeze (
    input logic clk,
    input logic rst,
    input logic en,
    input logic [7:0] data
);
    a_frozen: assert property (@(posedge clk) disable iff (rst) en && $past(en) |-> $stable(data))
        else $error("data changed while enabled");
endmodule
