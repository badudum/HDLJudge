module chk_hold3 (
    input logic clk,
    input logic rst,
    input logic en
);
    a_min_width: assert property (@(posedge clk) disable iff (rst) $rose(en) |-> en[*3])
        else $error("en pulse shorter than 3 cycles");
endmodule
