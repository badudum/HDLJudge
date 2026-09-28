module chk_align (
    input logic clk,
    input logic rst,
    input logic valid,
    input logic ready,
    input logic [1:0] size,
    input logic [7:0] addr
);
    a_align:  assert property (@(posedge clk) disable iff (rst)
                  valid |-> size != 2'd3 && (size != 2'd1 || addr[0] == 1'b0) && (size != 2'd2 || addr[1:0] == 2'b00))
        else $error("misaligned or reserved-size access");
    a_stable: assert property (@(posedge clk) disable iff (rst) valid && !ready |=> $stable(addr) && $stable(size))
        else $error("address/size changed while stalled");
endmodule
