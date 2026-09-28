module chk_packet (
    input logic clk,
    input logic rst,
    input logic valid,
    input logic [7:0] data,
    input logic parity,
    input logic last
);
    int beats;
    always @(posedge clk) begin
        if (rst)                beats <= 0;
        else if (valid && last) beats <= 0;
        else if (valid)         beats <= beats + 1;
    end
    a_parity: assert property (@(posedge clk) disable iff (rst) valid |-> parity == ^data) else $error("parity error");
    a_last:   assert property (@(posedge clk) disable iff (rst) last |-> valid) else $error("last without valid");
    a_length: assert property (@(posedge clk) disable iff (rst) valid && beats == 7 |-> last) else $error("packet longer than 8 beats");
endmodule
