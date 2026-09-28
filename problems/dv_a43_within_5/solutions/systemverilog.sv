module chk_ack (
    input logic clk,
    input logic rst,
    input logic req,
    input logic ack
);
    a_ack_within_5: assert property (@(posedge clk) disable iff (rst) req |-> ##[1:5] ack)
        else $error("req not acknowledged within 5 cycles");
endmodule
