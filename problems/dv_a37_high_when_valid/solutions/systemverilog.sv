module chk_valid_en (
    input logic clk,
    input logic rst,
    input logic valid,
    input logic en
);
    a_en_when_valid: assert property (@(posedge clk) disable iff (rst) valid |-> en)
        else $error("en is low while valid is high");
endmodule
