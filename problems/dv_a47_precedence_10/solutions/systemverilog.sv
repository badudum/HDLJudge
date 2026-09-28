module chk_precedence (
    input logic clk,
    input logic rst,
    input logic start,
    input logic done
);
    int since_start = 100;
    always @(posedge clk) begin
        if (rst)         since_start <= 100;
        else if (start)  since_start <= 1;
        else if (since_start < 100) since_start <= since_start + 1;
    end
    // since_start = cycles since the most recent start *before* this cycle
    a_precedence: assert property (@(posedge clk) disable iff (rst) done |-> since_start inside {[1:10]})
        else $error("done without a start in the previous 10 cycles");
endmodule
