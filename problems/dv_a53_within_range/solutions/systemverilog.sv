module chk_range (
    input logic clk,
    input logic rst,
    input logic valid,
    input logic [7:0] temp
);
    a_range: assert property (@(posedge clk) disable iff (rst) valid |-> temp inside {[8'd10:8'd90]})
        else $error("temp out of range");
endmodule
