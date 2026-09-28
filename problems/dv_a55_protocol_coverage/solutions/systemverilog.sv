module chk_proto (
    input logic clk,
    input logic rst,
    input logic req,
    input logic gnt,
    input logic done
);
    logic busy;
    always @(posedge clk) begin
        if (rst)       busy <= 1'b0;
        else if (req)  busy <= 1'b1;
        else if (done) busy <= 1'b0;
    end
    // (one property "req |-> ##[1:3] gnt ##[1:5] done" is the textbook form; Verilator does not
    //  report failures of chained range delays, so the two windows are checked separately)
    a_gnt:     assert property (@(posedge clk) disable iff (rst) req |-> ##[1:3] gnt) else $error("grant not within 1..3 cycles");
    a_done:    assert property (@(posedge clk) disable iff (rst) gnt |-> ##[1:5] done) else $error("done not within 1..5 cycles of grant");
    a_overlap: assert property (@(posedge clk) disable iff (rst) req |-> !busy) else $error("request while a transaction is open");
endmodule
