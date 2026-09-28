module chk_rise (
    input logic clk,
    input logic rst,
    input logic a,
    input logic pulse
);
    a_rise_has_pulse: assert property (@(posedge clk) disable iff (rst) $rose(a) |-> pulse)
        else $error("missing pulse on rising edge");
    a_pulse_only_on_rise: assert property (@(posedge clk) disable iff (rst) pulse |-> $rose(a))
        else $error("spurious pulse");
endmodule
