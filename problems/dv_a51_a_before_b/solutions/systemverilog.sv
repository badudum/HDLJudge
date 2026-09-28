module chk_order (
    input logic clk,
    input logic rst,
    input logic a,
    input logic b
);
    logic seen_a;
    always @(posedge clk) begin
        if (rst)    seen_a <= 1'b0;
        else if (a) seen_a <= 1'b1;
    end
    a_order: assert property (@(posedge clk) disable iff (rst) b |-> seen_a)
        else $error("b before a");
endmodule
