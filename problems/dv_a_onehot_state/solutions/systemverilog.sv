module chk_onehot (
    input logic clk,
    input logic rst,
    input logic [3:0] state
);
    a_onehot: assert property (@(posedge clk) disable iff (rst) $onehot(state))
        else $error("state %b is not one-hot", state);
endmodule
