module chk_power_seq (
    input logic clk,
    input logic rst,
    input logic pwr_en,
    input logic iso_en,
    input logic save,
    input logic restore
);
    logic saved, restored;
    always @(posedge clk) begin
        if (rst) begin
            saved <= 1'b0; restored <= 1'b0;
        end else begin
            if (!iso_en)            saved <= 1'b0;
            else if (save)          saved <= 1'b1;
            if (!pwr_en)            restored <= 1'b0;
            else if (restore)       restored <= 1'b1;
        end
    end
    a_iso_first: assert property (@(posedge clk) disable iff (rst) $fell(pwr_en) |-> iso_en && $past(iso_en)) else $error("power removed without isolation");
    a_saved:     assert property (@(posedge clk) disable iff (rst) $fell(pwr_en) |-> saved) else $error("power removed without state save");
    a_release:   assert property (@(posedge clk) disable iff (rst) $fell(iso_en) |-> pwr_en && $past(pwr_en) && restored) else $error("isolation released too early");
endmodule
