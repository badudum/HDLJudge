module chk_reset_value (
    input logic clk,
    input logic rst,
    input logic [3:0] count
);
    a_reset_value: assert property (@(posedge clk) rst |=> count == 4'd0)
        else $error("count is not zero after reset");
endmodule
