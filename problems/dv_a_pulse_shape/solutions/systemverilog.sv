module chk_pulse (
    input logic clk,
    input logic rst,
    input logic strobe
);
    a_width: assert property (@(posedge clk) disable iff (rst) strobe |=> !strobe) else $error("pulse wider than 1 cycle");
    a_gap:   assert property (@(posedge clk) disable iff (rst) $fell(strobe) |=> !strobe) else $error("pulses closer than 2 idle cycles");
endmodule
