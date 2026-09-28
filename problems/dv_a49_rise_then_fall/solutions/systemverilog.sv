module chk_pulse_width (
    input logic clk,
    input logic rst,
    input logic a
);
    a_width: assert property (@(posedge clk) disable iff (rst) $rose(a) |-> ##[2:4] $fell(a))
        else $error("pulse width outside 2..4 cycles");
endmodule
