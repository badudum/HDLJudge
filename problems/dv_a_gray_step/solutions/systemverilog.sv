module chk_gray (
    input logic clk,
    input logic rst,
    input logic [3:0] cnt
);
    a_gray: assert property (@(posedge clk) disable iff (rst) $countones(cnt ^ $past(cnt)) <= 1)
        else $error("more than one bit changed");
endmodule
